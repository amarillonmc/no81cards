--黄金的歌者 伊甸
function c32131325.initial_effect(c) 
	aux.AddCodeList(c,32131324)
	aux.AddMaterialCodeList(c,32131324)
	--code
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetCode(EFFECT_ADD_CODE) 
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE) 
	e0:SetRange(0xff) 
	e0:SetValue(32131324) 
	c:RegisterEffect(e0)
	--link summon
	aux.AddLinkProcedure(c,nil,2,99,c32131325.lcheck)
	c:EnableReviveLimit() 
	--to deck and draw 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)	  
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,32131325) 
	e1:SetCondition(c32131325.tddcon)
	e1:SetTarget(c32131325.tddtg) 
	e1:SetOperation(c32131325.tddop) 
	c:RegisterEffect(e1) 
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(32131325,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(c32131325.sptg)
	e3:SetOperation(c32131325.spop)
	c:RegisterEffect(e3)
end 
c32131325.SetCard_HR_flame13=true 
c32131325.HR_Flame_CodeList=32131324 
function c32131325.lcheck(g)
	return g:IsExists(Card.IsLinkCode,1,nil,32131324) 
end 
function c32131325.ckfil(c) 
	return c:IsFaceup() and c.SetCard_HR_flame13   
end 
function c32131325.tddcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c32131325.ckfil,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
end 
function c32131325.tddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_DECK) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1) 
end 
function c32131325.tddop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil) 
	if g:GetCount()<=0 then return end 
	local sg=g:Select(tp,1,1,nil) 
	if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0 then 
	   local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	   Duel.Draw(tp,1,REASON_EFFECT) 
	   if tc:IsType(TYPE_MONSTER) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(32131325,0)) then 
	   Duel.ConfirmCards(1-tp,tc) 
	   Duel.Draw(tp,1,REASON_EFFECT) 
	   end 
	end 
end 
function c32131325.spfilter(c,e,tp)
	return c.SetCard_HR_flame13 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c32131325.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c32131325.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c32131325.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c32131325.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end







