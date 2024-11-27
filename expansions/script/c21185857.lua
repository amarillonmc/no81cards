--你必须娶我为对象
function c21185857.initial_effect(c)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ADJUST)
	e0:SetRange(0xff)
	e0:SetOperation(c21185857.op)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(21185857)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	c:RegisterEffect(e1)
	--[[if not c21185857_ then
		c21185857_=true 
		c21185857_tab = {}
		c21185857_check_hack = Effect["IsHasProperty"]
		Effect["IsHasProperty"] = function(effect,p1,p2,...)
			if not Duel.IsPlayerAffectedByEffect(effect:GetHandlerPlayer(),21185857) then
				for i = 1,#c21185857_tab do
					if effect==c21185857_tab[i] then break
						return false
					end				
				end
				return c21185857_check_hack(effect,p1,p2,...)
			else
				return c21185857_check_hack(effect,p1,p2,...)
			end
		end
	end]]
end
function c21185857.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(0,0xff,0xff)
	if #g<=0 then return end
	local c21185857_RegisterEffect = Card["RegisterEffect"]	
	Card["RegisterEffect"] = function(card,effect,bool,...)
		if not effect:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and effect:IsActivated() then		
			local pro = effect:GetProperty() or 0
			effect:SetProperty(pro + EFFECT_FLAG_CARD_TARGET)
			local target = effect:GetTarget() or aux.TRUE
			effect:SetTarget(
				function(ne,ntp,neg,nep,nev,nre,nr,nrp,nchk) 
				if nchk==0 then return (not Duel.IsPlayerAffectedByEffect(ntp,21185857) or Duel.IsPlayerAffectedByEffect(ntp,21185857) and Duel.IsExistingTarget(function(nc) return nc:IsFaceup() and nc:IsCode(21185857) end,ntp,0,4,1,nil)) and target(ne,ntp,neg,nep,nev,nre,nr,nrp,0) end				
					if Duel.IsPlayerAffectedByEffect(ntp,21185857) then
					Duel.Hint(3,ntp,HINTMSG_TARGET)
					Duel.SelectTarget(ntp,function(nc) return nc:IsFaceup() and nc:IsCode(21185857) end,ntp,0,4,1,1,nil)
					end
				do target(ne,ntp,neg,nep,nev,nre,nr,nrp,1) end
			end)
		end
		--c21185857_tab[#c21185857_tab+1] = effect		
		c21185857_RegisterEffect(card,effect,bool,...)	
	end
	for tc in aux.Next(g) do
		if tc:GetOriginalCodeRule()~=21185857 then
		local card_code = _G["c"..tc:GetOriginalCode()]	
		tc:ReplaceEffect(21185858,0,0)
			do card_code.initial_effect(tc) end
		end
	end
	Card["RegisterEffect"] = c21185857_RegisterEffect
	e:Reset()
end