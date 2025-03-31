--吸血鬼魔血 二次脉搏
function c9911072.initial_effect(c)
	aux.AddCodeList(c,9911056)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c9911072.target)
	e1:SetOperation(c9911072.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9911072)
	e2:SetCost(c9911072.setcost)
	e2:SetTarget(c9911072.settg)
	e2:SetOperation(c9911072.setop)
	c:RegisterEffect(e2)
end
function c9911072.spfilter(c,e,tp)
	return c:IsSetCard(0x8e,0x9954) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9911072.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9911072.spfilter(chkc,e,tp,check) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9911072.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9911072.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9911072.checkfilter(c)
	return c:IsCode(9911056) and c:IsFaceup()
end
function c9911072.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(c9911072.checkfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsPlayerCanDraw(tp,1)
		and Duel.SelectYesNo(tp,aux.Stringid(9911072,0)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c9911072.setfilter(c)
	return c:IsSetCard(0x8e,0x9954) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c9911072.setcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local st=Duel.GetTargetCount(c9911072.setfilter,tp,LOCATION_GRAVE,0,e:GetHandler())
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local maxc=math.min(st,ft,2)
	if chk==0 then return maxc>0 and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk) and Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.RemoveOverlayCard(tp,1,0,1,maxc,REASON_COST)
	e:SetLabel(ct)
end
function c9911072.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9911072.setfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9911072.setfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	local ct=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c9911072.setfilter,tp,LOCATION_GRAVE,0,ct,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,g:GetCount(),0,0)
end
function c9911072.setop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if #tg==0 or ft<=0 then return end
	if #tg>ft then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		tg=tg:Select(tp,1,ft,nil)
	end
	Duel.SSet(tp,tg)
end
