--战争迷雾
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	for i=0,1 do
		local g=Duel.GetFieldGroup(i,0,LOCATION_EXTRA)
		local tc=g:RandomSelect(i,1):GetFirst()
		if tc then
			tc:SetCardData(CARDDATA_TYPE,Duel.ReadCard(tc,CARDDATA_TYPE))
		end
	end
end