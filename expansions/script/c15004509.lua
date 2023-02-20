local m=15004509
local cm=_G["c"..m]
cm.name="理智漫游者"
function cm.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
end
function cm.atkval(e,c)
	local g=Duel.GetFieldGroup(c:GetControler(),0,LOCATION_ONFIELD)
	local tc=g:GetFirst()
	local ct=0
	while tc do
		local setcounter=0x1
		while setcounter<0x2000 do
			ct=ct+tc:GetCounter(setcounter)
			setcounter=setcounter+0x1
		end
		tc=g:GetNext()
	end
	return ct*200
end