--异样的风暴中心
local m=11451000
local cm=_G["c"..m]
function cm.initial_effect(c)
	if STRANGE_EYE_OF_STORM==nil then
		STRANGE_EYE_OF_STORM=true
		local _Destroy=Duel.Destroy
		local _Damage=Duel.Damage
		function Duel.Destroy(tg,r,_)
			if bit.band(r,REASON_EFFECT)~=0 then
				local num=Duel.SendtoGrave(tg,r)
				return num
			end
			local num=_Destroy(tg,r,_)
			return num
		end
		function Duel.Damage(tp,val,r,_)
			if bit.band(r,REASON_EFFECT)~=0 then
				Duel.SetLP(tp,Duel.GetLP(tp)-val)
				return val
			end
			local dam=_Damage(tp,val,r,_)
			return dam
		end
	end
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PREDRAW)
	e0:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e0:SetRange(LOCATION_HAND+LOCATION_DECK)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e1)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
	if c:IsLocation(LOCATION_DECK) then Duel.ConfirmCards(tp,c) end
end