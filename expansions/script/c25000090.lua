local m=25000090
local cm=_G["c"..m]
cm.name="立！击！斩！"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(cm.condition1)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetCondition(cm.condition2)
	c:RegisterEffect(e2)
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return tc:IsDefensePos() and tc:IsControler(tp)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(function(c,tp)return c:IsDefensePos() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)end,nil,tp)
	return rp==1-tp and #g==1
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc==eg:GetFirst() end
	if chk==0 then return eg:GetFirst():IsCanChangePosition() end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(function(c,e,tp)return c:IsDefensePos() and c:IsControler(tp) and c:IsRelateToEffect(e)end,nil,e,tp)
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if #g>0 and #dg>0 then
		Duel.ChangePosition(g:GetFirst(),POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=dg:Select(tp,1,1,nil)
		if Duel.Destroy(sg,REASON_EFFECT)~=0 and eg:GetFirst():IsPosition(POS_FACEUP_ATTACK) and eg:GetFirst():GetAttack()>0 then Duel.Damage(1-tp,eg:GetFirst():GetAttack(),REASON_EFFECT) end
	end
end
