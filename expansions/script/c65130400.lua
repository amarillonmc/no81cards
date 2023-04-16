--限制呼唤
function c65130400.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c65130400.tg)
	e1:SetOperation(c65130400.op)
	c:RegisterEffect(e1)
end

Llist = {}
function c65130400.Llistr(f,limit)
	if f then
	local fp=f:read("*line")
	while fp do
		while true do
			if string.sub(fp,1,1)== '#' then
				break
			end
			if string.sub(fp,1,1)== '!' then
				Debug.Message("卡表："..fp)
				fp=f:read("*line")
				while string.sub(fp,1,1)~= '!' do
					local code=0
						if string.sub(fp,1,1)~= '#' then
							code=0
							for word in string.gmatch(fp,"%d+") do 
								code=code+tonumber(word)
								if tonumber(word)==limit then
									table.insert(Llist, code-limit)
									--Debug.Message(code)
									--Duel.Hint(HINT_CARD,0,code)
								end
							end							
						end
						fp=f:read("*line")
					end
					return			   
				end
				break
			end
			fp=f:read("*line")
		end	
	f:close()
	end
end
function c65130400.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local limit=Duel.SelectOption(tp,aux.Stringid(65130400,0),aux.Stringid(65130400,1),aux.Stringid(65130400,2))
	e:SetLabel(limit)
end
function c65130400.op(e,tp,eg,ep,ev,re,r,rp)	
	c65130400.Llistr(io.open("lflist.conf","r"),e:GetLabel())
	c65130400.Llistr(io.open("expansions/lflist.conf","r"),e:GetLabel())
	local k =math.random(#Llist)
	local tcode=Llist[k]
	local pc=Duel.CreateToken(tp,tcode)
	Duel.SendtoHand(pc,nil,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,tcode)
	Llist = {}
end
