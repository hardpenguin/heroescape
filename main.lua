function love.load()

	started=0
	
	square=50
	max_x=800
	max_y=600
	mmov=1 -- monster movement ratio
	moves=0 -- how many moves did player make
	
	turns_m=0 -- how many turns passed since monster was deleted
	turns_s=0 -- same but with scrolls
	
	turns=1 -- how many turns passed since the game started
	mnstr_killed=0
	
	
	lost=0
	won=0 
	
	rpt=1
	
	stones_amnt=20
	
	mnstr_amnt=6 -- monsters amount
	scrls_amnt=2 -- scrolls amount
	
	shrns_amnt=1
	obstcl_amnt=16 -- obstacles amount
	trap_amnt=4 -- traps amount
	wayout_amnt=1 -- exits amount
	
	scrl_carried=0
	scrl_used=0
	
	message=" "
	message2=" "
	message3=" "
	message4=" "
	message5=" "
	
	menu_bg=love.graphics.newImage("graphics/menu_bg.png")
	
	hero_die=love.audio.newSource("sounds/hero_die.mp3", "static")
	hero_hooray=love.audio.newSource("sounds/hero_hooray.mp3", "static")
	hero_pickup=love.audio.newSource("sounds/hero_pickup.mp3", "static")
	monster_die=love.audio.newSource("sounds/monster_die.mp3", "static")
	monster_spawn=love.audio.newSource("sounds/monster_spawn.mp3", "static")
	teleport=love.audio.newSource("sounds/teleport.mp3", "static")
	burn=love.audio.newSource("sounds/burn.mp3", "static")
	
	trap_img=love.graphics.newImage("graphics/trap.png")
	obstacle_img=love.graphics.newImage("graphics/obstacle.png")
	wayout_img=love.graphics.newImage("graphics/wayout.png")
	shrine_img=love.graphics.newImage("graphics/shrine.png")
	
	hero_img=love.graphics.newImage("graphics/hero.png")
	monster_img=love.graphics.newImage("graphics/monster.png")
	scroll_img=love.graphics.newImage("graphics/scroll.png")
	
	burn_img=love.graphics.newImage("graphics/burn.png")
	teleport_img=love.graphics.newImage("graphics/teleport.png")

	
	stones_img=love.graphics.newImage("graphics/stones.png")
	
	
	math.randomseed(os.time())
		
	objects_x={}
	objects_y={}
	
	-- map decoration
	
	stones={}
	for i=1,stones_amnt do
		stone={}
			stone.x=math.random(max_x/square)*square-square
			stone.y=math.random(max_y/square)*square-square
		table.insert(stones,stone)
	end
	
	
	-- not moving stuff
	
	
	traps={}
	rpt=1	
	for i=1,trap_amnt do
		trap={}
			trap.x=math.random(max_x/square)*square-square
			trap.y=math.random(max_y/square)*square-square
		table.insert(traps,trap)
		table.insert(objects_x,trap.x)
		table.insert(objects_y,trap.y)
	end
	
	obstacles={}
	rpt=1
	for i=1,obstcl_amnt do
		obstacle={}
		repeat
			obstacle.x=math.random(max_x/square)*square-square
			obstacle.y=math.random(max_y/square)*square-square
			for i=1,#objects_x do
				if objects_x[i]==obstacle.x and objects_y[i]==obstacle.y then
					rpt=1
					break
				else
					rpt=0
				end
			end
		until rpt==0
		table.insert(obstacles,obstacle)
		table.insert(objects_x,obstacle.x)
		table.insert(objects_y,obstacle.y)
	end
	
	wayouts={}
	rpt=1
	for i=1,wayout_amnt do
		wayout={}
		repeat
			wayout.x=math.random(max_x/square)*square-square
			wayout.y=math.random(max_y/square)*square-square
			for i=1,#objects_x do
				if objects_x[i]==wayout.x and objects_y[i]==wayout.y then
					rpt=1
					break
				else
					rpt=0
				end
			end
		until rpt==0
		table.insert(wayouts,wayout)
		table.insert(objects_x,wayout.x)
		table.insert(objects_y,wayout.y)
	end
	
	shrines={}
	rpt=1
	for i=1,shrns_amnt do
		shrine={}
		repeat
			shrine.x=math.random(max_x/square)*square-square
			shrine.y=math.random(max_y/square)*square-square
			for i=1,#objects_x do
				if objects_x[i]==shrine.x and objects_y[i]==shrine.y then
					rpt=1
					break
				else
					rpt=0
				end
			end
		until rpt==0
		table.insert(shrines,shrine)
		table.insert(objects_x,shrine.x)
		table.insert(objects_y,shrine.y)
	end
	
	-- dynamic stuff
	
	hero={}
	repeat
		hero.x=math.random(max_x/square)*square-square
		hero.y=math.random(max_y/square)*square-square
		for i=1,#objects_x do
			if (objects_x[i]==hero.x and objects_y[i]==hero.y) or ((math.abs(wayout.x-hero.x)<7*square))  then
				rpt=1
				break
			else
				rpt=0
			end
		end
	until rpt==0
	
	scrolls={}
	rpt=1
	for i=1,scrls_amnt do
		scroll={}
		repeat
			scroll.x=math.random(max_x/square)*square-square
			scroll.y=math.random(max_y/square)*square-square
			for i=1,#objects_x do
				if objects_x[i]==scroll.x and objects_y[i]==scroll.y then
					rpt=1
					break
				else
					rpt=0
				end
			end
		until scroll.x~=hero.x and scroll.y~=hero.y and rpt==0
		table.insert(scrolls,scroll)
	end
	
	
	monsters={}
	rpt=1
	for i=1,mnstr_amnt do
		monster={}
		repeat
			monster.x=math.random(max_x/square)*square-square
			monster.y=math.random(max_y/square)*square-square
			for i=1,#objects_x do
				if objects_x[i]==monster.x and objects_y[i]==monster.y then
					rpt=1
					break
				else
					rpt=0
				end
			end
		until monster.x~=hero.x and monster.y~=hero.y and rpt==0
		table.insert(monsters,monster)
	end
		
	hero_old={}
	hero_old.x=hero.x
	hero_old.y=hero.y
	
	monster_old={}
	monsters_old={}	
	
	rpt=1
		
	m_t_k={0} -- monsters to kill
	
	fx1=0
	fx2=0
	fx_t=0
end


---


function round2(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end -- taken from lua-users wiki


---


function messages(msg)
	
		message5=message4
		message4=message3
		message3=message2
		message2=message
		message=msg
	
end


---



function love.keyreleased(key)
	
	hero_old.x=hero.x
	hero_old.y=hero.y
		
	if lost==0 and won==0 and fx1==0 and fx2==0 then	
		if (key=="left") then
			hero.x=hero.x-square
			moves=moves+1
		elseif (key=="right") then
			hero.x=hero.x+square
			moves=moves+1
		elseif (key=="up") then
			hero.y=hero.y-square
			moves=moves+1
		elseif (key=="down") then
			hero.y=hero.y+square
			moves=moves+1 -- this is done for movement
		elseif (key=="return") then
			started=1
			if scrl_carried~=0 then
				scrl_used=1
				moves=moves+1	
			end
		end
	end
		
	if(key=="r") then
			love.load()
			started=1
	end
		
	if key == "escape" then
		love.event.quit()
		
	end

end


---


function love.update(dt)


	
	for i,v in ipairs(obstacles) do
		if hero.x==v.x and hero.y==v.y then
			hero.x=hero_old.x
			hero.y=hero_old.y
			moves=moves-1
		end
	end
	
	
	if hero.x>(max_x-square) then
		hero.x=hero.x-square
		moves=moves-1
	elseif hero.x<0 then
		hero.x=hero.x+square
		moves=moves-1
	elseif hero.y>(max_y-square) then
		hero.y=hero.y-square
		moves=moves-1
	elseif hero.y<0 then
		hero.y=hero.y+square
		moves=moves-1
	end -- to prevent escaping the map borders
	
	if fx1~=0 and (love.timer.getTime()-fx_t)>1 then
		fx1=0
		fx_t=0
	end
	
	if fx2~=0 and (love.timer.getTime()-fx_t)>1 then
		fx2=0
		fx_t=0
	end
		
	
	if scrl_used==1 then
		if scrl_carried==1 then
		
			hero.x=shrine.x
			hero.y=shrine.y

			teleport:play()
			messages("You have teleported!")
			fx1=1
			fx_t=love.timer.getTime()
			
		elseif scrl_carried==2 then
			
			burn:play()
			
			for i,v in ipairs(monsters) do -- BURNING IN ALPHA, USE WITH PRECAUTION
			
				if (v.x==hero.x-square or v.x==hero.x or v.x==hero.x+square) and (v.y==hero.y-square or v.y==hero.y or v.y==hero.y+square) then
					table.insert(m_t_k,i)
					messages("You burned a monster!")
					mnstr_killed=mnstr_killed+1
				end
				
			end
			
			for i=#m_t_k, 1, -1 do
				table.remove(monsters,m_t_k[i])
			end
			
			m_t_k={0}
			
			fx2=1
			fx_t=love.timer.getTime()
		end
		
		scrl_carried=0
		scrl_used=0
	end

	
	monsters_old={0}
	
	for l,t in ipairs(monsters) do
		monster_old.x=t.x
		monster_old.y=t.y
		table.insert(monsters_old,monster_old)
	end		
	
	
	if moves>0 then
	
		if hero.x==wayout.x and hero.y==wayout.y then
			won=1
			hero_hooray:play()
			messages("You escaped the area!")
			moves=0
		end
		
		for i,v in ipairs(traps) do
			if hero.x==v.x and hero.y==v.y then
				lost=1
				hero_die:play()
				messages("You fell on spikes!")
				moves=0
			end
		end
		
		for i,v in ipairs(scrolls) do
			if hero.x==v.x and hero.y==v.y then
				table.remove(scrolls,i)
				hero_pickup:play()
				messages("You found a magic scroll!")
				
				
				scrl_carried=math.random(2) -- 1 is teleportation spell, 2 is fire circle spell
								
			end
		end
		
	end
	
	if moves>1 then

		
		if #scrolls<scrls_amnt then
			turns_s=turns_s+1
		end
		

		
		if turns_s==6 then
			scroll={}
			repeat
				scroll.x=math.random(max_x/square)*square-square
				scroll.y=math.random(max_y/square)*square-square
				for i=1,#objects_x do
					if objects_x[i]==scroll.x and objects_y[i]==scroll.y then
						rpt=1
						break
					else
						rpt=0
					end
				end
			until scroll.x~=hero.x and scroll.y~=hero.y and rpt==0
				
			table.insert(scrolls,scroll)
						
			turns_s=0
		end
	
		
		for i,v in ipairs(monsters) do
			
		
			function monster_turn (xy,pn) -- do we talk about x or y position? do we add or subtract the value?
				if xy=="x" then
					v.x=v.x+pn*(square*mmov)
				elseif xy=="y" then
					v.y=v.y+pn*(square*mmov)
				end
				
				
				for j,u in ipairs(monsters) do
					if j==i then break end
					
					if  v.x==u.x and v.y==u.y then
			
						if  xy=="x" then
							v.x=v.x-pn*(square*mmov)
						elseif xy=="y" then
							v.y=v.y-pn*(square*mmov)
						end
							break
					end
			
				end
				
				for m,s in ipairs(obstacles) do
									
					if  v.x==s.x and v.y==s.y then
			
						if  xy=="x" then
							v.x=v.x-pn*(square*mmov)
						elseif xy=="y" then
							v.y=v.y-pn*(square*mmov)
						end
							break
					end
			
				end

			end
					
			if hero.x>v.x then
				monster_turn("x",1)
			end
			
			if hero.x<v.x then
				monster_turn("x",-1)
			end
			
			if hero.y>v.y then
				monster_turn("y",1)
			end
			
			if hero.y<v.y then
				monster_turn("y",-1)
			end
			

			for k,w in ipairs(traps) do
				if v.x==w.x and v.y==w.y then
					
					table.remove(monsters,i)
					monster_die:play()
					messages("Monster has died!")
					mnstr_killed=mnstr_killed+1
																	
				end
			end
		
			if v.x==hero.x and v.y==hero.y then
			    lost=1
			    hero_die:play()
			    messages("You were eaten!")
			end
				
		end -- monsters will chase the hero
		
		math.randomseed(os.time())
		
		if #monsters<mnstr_amnt then
			turns_m=turns_m+1
		end
		
		if turns_m==4 then
			monster={}
			repeat
				monster.x=math.random(max_x/square)*square-square
				monster.y=math.random(max_y/square)*square-square
			until monster.x~=hero.x and monster.y~=hero.y
				
			table.insert(monsters,monster)
			
			monster_spawn:play()
			messages("Monster has spawned!")
			
			turns_m=0
		end
	
		turns=turns+1
		
		moves=0
		
	end


end


---


function love.draw()

	-- whole background
	
	love.graphics.setColor(194,178,110,255) -- background color
	love.graphics.rectangle("fill",0,0,max_x,max_y)
	
	for i=0,max_x,square do -- draw the grid
			love.graphics.setColor(0,0,0,60)
			love.graphics.line(i,0,i,max_y)
	end
	
	for i=0,max_y,square do
			love.graphics.setColor(0,0,0,60)
			love.graphics.line(0,i,max_x,i)
	end
	
	-- stones
		
	love.graphics.setColor(255,255,255,170)
	for i,v in ipairs(stones) do
		love.graphics.draw(stones_img,v.x,v.y)
	end
	
	
	-- traps
	
	love.graphics.setColor(255,255,255,255)
	for i,v in ipairs(traps) do
		love.graphics.draw(trap_img,v.x,v.y)
	end
	
	-- obstacles
	
	love.graphics.setColor(255,255,255,255)
	for i,v in ipairs(obstacles) do
		love.graphics.draw(obstacle_img,v.x,v.y)
	end
	
	-- shrines
	
	love.graphics.setColor(255,255,255,255)
	for i,v in ipairs(shrines) do
		love.graphics.draw(shrine_img,v.x,v.y)
	end
	
	-- wayouts
	
	love.graphics.setColor(255,255,255,255)
	for i,v in ipairs(wayouts) do
		love.graphics.draw(wayout_img,v.x,v.y)
	end
	
	-- scrolls
	
	love.graphics.setColor(255,255,255,255)
	for i,v in ipairs(scrolls) do
		love.graphics.draw(scroll_img,v.x,v.y)
	end
	
	-- hero
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(hero_img,hero.x,hero.y)
	
	-- monsters
	
	love.graphics.setColor(255,255,255,255)
	for i,v in ipairs(monsters) do
		love.graphics.draw(monster_img,v.x,v.y)
	end
		
	love.graphics.setColor(255,255,255,50)
	love.graphics.rectangle("fill", max_x-384, 11, 135, 55)	
		
	love.graphics.setColor(0,0,0,190)
	love.graphics.print("Turn: " .. turns, max_x-380, 15)
	love.graphics.print("Monsters killed: " .. mnstr_killed, max_x-380, 30)
	
	-- scroll currently owned
	
	love.graphics.setColor(255,255,255,50)
	love.graphics.rectangle("fill", max_x-244, 11, 55, 55)
	
	love.graphics.setColor(255,255,255,255)
	if scrl_carried==0 then
		
	elseif scrl_carried==1 then
		love.graphics.draw(teleport_img, max_x-240, 11)
	elseif scrl_carried==2 then
		love.graphics.draw(burn_img, max_x-240, 11)
	end

	love.graphics.setColor(255,255,255,255)
	
	if fx1==1 then
		love.graphics.draw(teleport_img, hero_old.x, hero_old.y)
		love.graphics.draw(teleport_img, hero.x, hero.y)
	end
	
	if fx2==1 then
		love.graphics.draw(burn_img, hero.x-square, hero.y-square)
		love.graphics.draw(burn_img, hero.x-square, hero.y)
		love.graphics.draw(burn_img, hero.x-square, hero.y+square)
		love.graphics.draw(burn_img, hero.x, hero.y-square)
		love.graphics.draw(burn_img, hero.x, hero.y+square)
		love.graphics.draw(burn_img, hero.x+square, hero.y-square)
		love.graphics.draw(burn_img, hero.x+square, hero.y)
		love.graphics.draw(burn_img, hero.x+square, hero.y+square)
	end

	-- game log
	
	love.graphics.setColor(255,255,255,50)
	love.graphics.rectangle("fill", max_x-184, 11, 164, 85)
	
	love.graphics.setColor(0,0,0,190)
	love.graphics.print(message, max_x-180, 15)
	love.graphics.print(message2, max_x-180, 30)
	love.graphics.print(message3, max_x-180, 45)
	love.graphics.print(message4, max_x-180, 60)
	love.graphics.print(message5, max_x-180, 75)
		
	-- youlost/youwon
	
	won_scr=2000
	mnstr_scr=500
	spc1=180
	
	function score()
		score_spc=320
		love.graphics.print('Your score:', score_spc, 245)
		
		love.graphics.print('Game won/lost: ' .. won .. ' x ' .. '2000', score_spc, 260)
		love.graphics.print(' = ' .. won*won_scr, score_spc+spc1,260)
		
		love.graphics.print('+', score_spc+spc1-100, 275)
		
		love.graphics.print('Monsters killed: ' .. mnstr_killed .. ' x ' .. '500', score_spc, 290)
		love.graphics.print(' = ' .. mnstr_killed*mnstr_scr, score_spc+spc1, 290)
				
		love.graphics.print(' = ' .. won*won_scr+mnstr_killed*mnstr_scr, score_spc+spc1, 320)
		
		love.graphics.print('x', score_spc+spc1-100, 335)
		
		love.graphics.print('20/' .. 'Turns passed: ' .. turns .. ' = ', score_spc, 350)
		love.graphics.print(' = ' .. round2(20/turns, 2), score_spc+spc1, 350)
				
		love.graphics.print('Total: ', score_spc, 380)
		love.graphics.print(' = ' .. round2((won*won_scr+mnstr_killed*mnstr_scr)*(20/turns), 0), score_spc+spc1, 380)
		
		love.graphics.print('Press R to play again, ESC to quit', score_spc, 410)
	end
	
	if lost~=0 then
		love.graphics.setColor(255,255,255,130)
		love.graphics.rectangle("fill",0,0,max_x,max_y)
	
		love.graphics.setColor(0,0,0,255)
		love.graphics.print('You lost!', 370, 200)
		score()
	end
	
	if won~=0 then
		love.graphics.setColor(255,255,255,130)
		love.graphics.rectangle("fill",0,0,max_x,max_y)
	
		love.graphics.setColor(0,0,0,255)
		love.graphics.print('You WON!', 370, 200)
		score()
	end
	
	
    if started==0 then
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(menu_bg, 0, 0)		
	end
	
end
