--捕兽夹
function c16101107.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16101107,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c16101107.target)
	e1:SetOperation(c16101107.operation)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e5)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c16101107.handcon)
	c:RegisterEffect(e2)
end
function c16101107.cfilter(c,tp)
	return (c:IsRace(RACE_BEAST) or c:IsRace(RACE_BEASTWARRIOR) or c:IsRace(RACE_WINDBEAST)) and c:GetSummonPlayer()==1-tp and c:IsFaceup()
end
function c16101107.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return eg:IsExists(c16101107.cfilter,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>eg:Filter(c16101107.cfilter,nil,tp):GetCount()-1 end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,eg:GetCount(),0,0)
end
function c16101107.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c16101107.cfilter,nil,tp)
	if g:GetCount()>Duel.GetLocationCount(tp,LOCATION_MZONE) then return end
	local tc=g:GetFirst()
	while tc do
		if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.GetControl(tc,tp)~=0 then
			 tc:RegisterFlagEffect(16101107,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(16101107,1))
		end
		tc=g:GetNext()
	end
end
function c16101107.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end