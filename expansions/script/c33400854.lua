--八舞 双子斗争
local m=33400854
local cm=_G["c"..m]
function cm.initial_effect(c)
	   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
--move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.mvtg)
	e3:SetOperation(cm.mvop)
	c:RegisterEffect(e3)
	local e2=e3:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.con)
	c:RegisterEffect(e2) 

end
function cm.filter(c,tp)
	local cg=c:GetColumnGroup():Filter(Card.IsControler,nil,1-tp) 
	return c:IsFaceup() and c:IsSetCard(0xa341) and cg:GetCount()>0
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.filter(chkc,tp) end
	local ft=0
	if chk==0 then return  Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local cg=tc:GetColumnGroup():Filter(Card.IsControler,nil,1-tp) 
	if tc:IsRelateToEffect(e) and tc:IsFaceup()  and cg:GetCount()>0  then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=cg:Select(tp,1,1,nil)
		local tc1=g:GetFirst()
		if not tc:IsLevel(4) and  tc1:IsAbleToDeck()   and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.SendtoDeck(tc1,nil,2,REASON_EFFECT)
		else
		Duel.Destroy(tc1,REASON_EFFECT)
		end
	end
end
function cm.ckfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xa341) and c:IsType(TYPE_CONTINUOUS) and c:IsType(TYPE_SPELL)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.mvfilter2(c,tp)
	return c:IsFaceup()  and c:GetSequence()<5
		and Duel.IsExistingMatchingCard(cm.mvfilter3,tp,LOCATION_MZONE,0,1,c)
end
function cm.mvfilter3(c)
	return c:IsFaceup()  and c:GetSequence()<5
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.mvfilter2,tp,LOCATION_MZONE,0,1,nil,tp) end
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local g1=Duel.SelectMatchingCard(tp,cm.mvfilter2,tp,LOCATION_MZONE,0,1,1,nil,tp)
		local tc1=g1:GetFirst()
		if not tc1 then return end
		Duel.HintSelection(g1)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local g2=Duel.SelectMatchingCard(tp,cm.mvfilter3,tp,LOCATION_MZONE,0,1,1,tc1)
		Duel.HintSelection(g2)
		local tc2=g2:GetFirst()
		Duel.SwapSequence(tc1,tc2)
end
