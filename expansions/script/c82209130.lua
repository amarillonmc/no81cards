--残械炮
local m=82209130
local cm=_G["c"..m]
function cm.initial_effect(c)
	--end battle phase  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)  
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)  
	e1:SetRange(LOCATION_HAND)  
	e1:SetCondition(cm.condition)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1)  
end  
function cm.condition(e,tp,eg,ep,ev,re,r,rp)  
	local at=Duel.GetAttacker()  
	return at:GetControler()~=tp and Duel.GetAttackTarget()==nil and at:GetAttack()>=Duel.GetLP(tp) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==0
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler() 
	local at=Duel.GetAttacker()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetTargetCard(at)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,at:GetAttack()) 
	Duel.SetChainLimit(aux.FALSE)  
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then  
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsAttackable() and not tc:IsStatus(STATUS_ATTACK_CANCELED) and tc:GetAttack()>0 then
			Duel.Damage(1-tp,tc:GetAttack(),REASON_EFFECT)
		end
	end  
end  