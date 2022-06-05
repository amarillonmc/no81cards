--狂邪魔凰之交杀
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(cm.con1)
	e1:SetCost(cm.cos1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function cm.cosf1(c)
	return c:IsSetCard(0xfd6) and c:IsType(TYPE_MONSTER)
end
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.cosf1,1,nil) end
	local tc=Duel.SelectReleaseGroup(tp,cm.cosf1,1,1,nil):GetFirst()
	if Duel.Release(tc,REASON_COST)~=0 and tc:IsSetCard(0x3fd6) then e:SetLabel(1) end
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
	local sg=Duel.GetOperatedGroup()
	g:Sub(sg)
	if e:GetLabel()==1 and #g>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end