local m=53796138
local cm=_G["c"..m]
cm.name="规则守护者"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(m)
	e1:SetRange(LOCATION_EXTRA)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		cm[1]=Duel.CreateToken
		Duel.CreateToken=function(tp,code)
			local tc=cm[1](tp,code)
			if tc then tc:RegisterFlagEffect(m,0,0,0) end
			return tc
		end
		cm[2]=Duel.MoveToField
		Duel.MoveToField=function(sc,...)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and sc:GetFlagEffect(m)>0 then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return false
			else return cm[2](sc,...) end
		end
		cm[3]=Duel.SpecialSummon
		Duel.SpecialSummon=function(tg,...)
			tg=Group.__add(tg,tg)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and tg:IsExists(function(c)return c:GetFlagEffect(m)>0 and not c:IsType(TYPE_TOKEN)end,1,nil) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return cm[3](tg,...) end
		end
		cm[4]=Duel.SpecialSummonStep
		Duel.SpecialSummonStep=function(sc,...)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and sc:GetFlagEffect(m)>0 and not sc:IsType(TYPE_TOKEN) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return false
			else return cm[4](sc,...) end
		end
		cm[5]=Duel.SendtoDeck
		Duel.SendtoDeck=function(tg,...)
			tg=Group.__add(tg,tg)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and tg:IsExists(function(c)return c:GetFlagEffect(m)>0 end,1,nil) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return cm[5](tg,...) end
		end
		cm[6]=Duel.SendtoExtraP
		Duel.SendtoExtraP=function(tg,...)
			tg=Group.__add(tg,tg)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and tg:IsExists(function(c)return c:GetFlagEffect(m)>0 end,1,nil) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return cm[6](tg,...) end
		end
		cm[7]=Duel.SendtoGrave
		Duel.SendtoGrave=function(tg,...)
			tg=Group.__add(tg,tg)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and tg:IsExists(function(c)return c:GetFlagEffect(m)>0 end,1,nil) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return cm[7](tg,...) end
		end
		cm[8]=Duel.SendtoHand
		Duel.SendtoHand=function(tg,...)
			tg=Group.__add(tg,tg)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and tg:IsExists(function(c)return c:GetFlagEffect(m)>0 end,1,nil) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return cm[8](tg,...) end
		end
		cm[9]=Duel.Remove
		Duel.Remove=function(tg,...)
			tg=Group.__add(tg,tg)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and tg:IsExists(function(c)return c:GetFlagEffect(m)>0 end,1,nil) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return cm[9](tg,...) end
		end
		cm[10]=Duel.Overlay
		Duel.Overlay=function(sc,tg)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and tg:IsExists(function(c)return c:GetFlagEffect(m)>0 end,1,nil) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return cm[10](sc,tg) end
		end
		cm[11]=Duel.Destroy
		Duel.Destroy=function(tg,...)
			tg=Group.__add(tg,tg)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and tg:IsExists(function(c)return c:GetFlagEffect(m)>0 end,1,nil) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return cm[11](tg,...) end
		end
		cm[12]=Duel.Equip
		Duel.Equip=function(tp,sc,ec,...)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and sc:GetFlagEffect(m)>0 then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return false
			else return cm[12](tp,sc,ec,...) end
		end
		cm[13]=Duel.Summon
		Duel.Summon=function(tp,sc,...)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and sc:GetFlagEffect(m)>0 then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return false
			else return cm[13](tp,sc,...) end
		end
		cm[14]=Duel.MSet
		Duel.MSet=function(tp,sc,...)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and sc:GetFlagEffect(m)>0 then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return false
			else return cm[14](tp,sc,...) end
		end
		cm[15]=Duel.SSet
		Duel.SSet=function(tp,tg,...)
			tg=Group.__add(tg,tg)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and tg:IsExists(function(c)return c:GetFlagEffect(m)>0 end,1,nil) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return cm[15](tp,tg,...) end
		end
		cm[16]=Duel.Release
		Duel.Release=function(tg,...)
			tg=Group.__add(tg,tg)
			local g=Duel.GetMatchingGroup(Card.IsHasEffect,0,LOCATION_EXTRA,LOCATION_EXTRA,nil,m)
			if #g>0 and tg:IsExists(function(c)return c:GetFlagEffect(m)>0 end,1,nil) then
				local sg=g:RandomSelect(0,1)
				Duel.ConfirmCards(0,sg)
				Duel.ConfirmCards(1,sg)
				return 0
			else return cm[16](tg,...) end
		end
	end
end
