--PRTS·网络桥接
function c82567827.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82567827)
	e1:SetTarget(c82567827.target)
	e1:SetOperation(c82567827.activate)
	c:RegisterEffect(e1)
	--AddCounter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,82567927)
	e2:SetTarget(c82567827.cttg)
	e2:SetOperation(c82567827.ctop)
	c:RegisterEffect(e2)
end
function c82567827.cfilter1(c,e,tp)
	local maxlink = Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,nil):GetMaxGroup(Card.GetLink):GetFirst()
	local lk = maxlink:GetLink()
	local lk = lk-1
	return c:IsSetCard(0x825) and c:IsType(TYPE_LINK) and lk>=c:GetLink() and c:IsLinkBelow(3) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c82567827.cfilter(c)
	return c:IsFacedown() and c:IsAbleToRemove(POS_FACEUP)
end
function c82567827.linkfilter(c)
	return c:IsType(TYPE_LINK)
end
function c82567827.target(e,tp,eg,ep,ev,re,r,rp,chk,lk,maxlink)
	if chk==0 then 
	local c=e:GetHandler()
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c82567827.linkfilter,tp,LOCATION_MZONE,0,1,nil)
	and Duel.IsExistingMatchingCard(c82567827.cfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c82567827.activate(e,tp,eg,ep,ev,re,r,rp,lk,maxlink)
	 if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82567827.cfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,maxlink,lk)
	if g:GetCount()>0  then
	  local  tc=g:GetFirst()
	  if  Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 then
		Duel.SpecialSummon(tc,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		 tc:CompleteProcedure()  
	 
   end
end
end
function c82567827.tkfilter(c)
	return c:IsType(TYPE_LINK) and c:IsSetCard(0x825) and c:IsFaceup()
end

function c82567827.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsCanAddCounter(0x5825,2) and chkc:IsType(TYPE_LINK) and chkc:IsSetCard(0x825) end
	if chk==0 then return Duel.IsExistingTarget(c82567827.tkfilter,tp,LOCATION_MZONE,0,1,nil,0x5825,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82567827.tkfilter,tp,LOCATION_MZONE,0,1,1,nil,0x5825,2)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x5825,2)
end
function c82567827.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(tp) and tc:IsSetCard(0x825) and tc:IsType(TYPE_LINK)
  then  tc:AddCounter(0x5825,2)
	end
end

