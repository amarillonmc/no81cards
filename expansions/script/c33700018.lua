--小姐！送水！
function c33700018.initial_effect(c)
  --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c33700018.condition)
	e1:SetTarget(c33700018.target)
	e1:SetOperation(c33700018.activate)
	c:RegisterEffect(e1)
end
function c33700018.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c33700018.filter(c,tp)
	return c:GetSummonPlayer()==1-tp and c:IsControlerCanBeChanged()
end
function c33700018.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c33700018.filter,nil,tp)
	if chk==0 then return g:GetCount()>0 and Duel.GetMZoneCount(tp)>=g:GetCount()-1 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function c33700018.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if Duel.GetMZoneCount(tp)<g:GetCount() then return end
	Duel.GetControl(g,tp)
end