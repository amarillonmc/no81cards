--strange eye of storm
--21.04.09
local cm,m=GetID()
function cm.initial_effect(c)
	if STRANGE_EYE_OF_STORM==nil then
		STRANGE_EYE_OF_STORM=true
		local _Destroy=Duel.Destroy
		local _Damage=Duel.Damage
		function Duel.Destroy(tg,r,_)
			if r&REASON_EFFECT>0 then
				Duel.Hint(HINT_CARD,0,m)
				return Duel.SendtoGrave(tg,r)
			end
			return _Destroy(tg,r,_)
		end
		function Duel.Damage(tp,val,r,_)
			if r&REASON_EFFECT>0 then
				Duel.Hint(HINT_CARD,0,m)
				Duel.SetLP(tp,Duel.GetLP(tp)-val)
				return val
			end
			return _Damage(tp,val,r,_)
		end
	end
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e0:SetRange(LOCATION_HAND+LOCATION_DECK)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,c)
	if c:IsLocation(LOCATION_DECK) then Duel.ConfirmCards(tp,c) end
	e:Reset()
end