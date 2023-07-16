--想和你玩火焰纹章的樱
local m=75000714
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.sprcon)
	c:RegisterEffect(e1)
	--Effect 2  
	local e02=Effect.CreateEffect(c)  
	e02:SetDescription(aux.Stringid(m,0))
	e02:SetType(EFFECT_TYPE_IGNITION)
	e02:SetRange(LOCATION_GRAVE)
	e02:SetCountLimit(1,m+m)
	e02:SetCondition(aux.exccon)
	e02:SetCost(aux.bfgcost)
	e02:SetTarget(cm.tg)
	e02:SetOperation(cm.op)
	c:RegisterEffect(e02)   
	--Effect 3 
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.cttg)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2) 
end
--Effect 1
function cm.filter(c)
	return c:IsSetCard(0x750) and c:IsFaceup()
end
function cm.sprcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.filter,c:GetControler(),LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
--Effect 2
function cm.f(c,tp)
	local mg=Duel.GetMatchingGroup(cm.f1,tp,0,LOCATION_MZONE,nil,c,c)
	local b1=c:IsFaceup() and c:IsSetCard(0x750) and c:IsPosition(POS_FACEUP_DEFENSE)
	return b1 and #mg>0
end
function cm.f1(c,ac)
	return c:IsCanBeBattleTarget(ac) and c:IsPosition(POS_FACEUP_DEFENSE)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.f,tp,LOCATION_MZONE,0,nil,tp)
	if chk==0 then return #g>0 end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.f,tp,LOCATION_MZONE,0,nil)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local tc=g:Select(tp,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local tcc=Duel.SelectMatchingCard(tp,cm.f1,tp,0,LOCATION_MZONE,1,1,nil,tc):GetFirst()
	local ag=Group.FromCards(tc,tcc)
	Duel.HintSelection(ag)
	Duel.ChangePosition(ag,POS_FACEUP_ATTACK)
	if ag:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)==2 
		and tc:IsPosition(POS_FACEUP_ATTACK) 
		and tcc:IsPosition(POS_FACEUP_ATTACK) then
		Duel.CalculateDamage(tc,tcc,true)
	end 
end
--Effect 3 
function cm.ctfilter(c,tp)
	return c:IsFaceup() and c:GetOwner()==tp and c:IsControlerCanBeChanged()
end
function cm.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.ctfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.ctfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,cm.ctfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.GetControl(tc,tp)
	end
end
