--异格干员-斯卡蒂
function c79029465.initial_effect(c)
	--add code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(79029010)
	c:RegisterEffect(e0) 
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79029465,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetOperation(c79029465.ntop)
	c:RegisterEffect(e1)  
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(c79029465.thtg)
	e2:SetOperation(c79029465.thop)
	c:RegisterEffect(e2) 
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79029465,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCountLimit(1,79029465)
	e3:SetCost(c79029465.spcost)
	e3:SetTarget(c79029465.sptg)
	e3:SetOperation(c79029465.spop)
	c:RegisterEffect(e3) 
end
c79029465.named_with_AbyssHunter=true 
function c79029465.ntop(e,tp,eg,ep,ev,re,r,rp,c)
	Debug.Message("我习惯了独行。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029465,2))
end
function c79029465.thfil(c) 
	return c:IsAbleToHand() and c.named_with_AbyssHunter
end
function c79029465.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029465.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_DECK)
end
function c79029465.thop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("和我面对过的灾厄相比，你们也太弱了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029465,3))
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029465.thfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sg)
	if Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) and Duel.CheckLPCost(tp,3000) and Duel.SelectYesNo(tp,aux.Stringid(79029465,1)) then
	Duel.PayLPCost(tp,3000)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	Debug.Message("这种程度的不幸，也只是个开始罢了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029465,4))
	Duel.Release(rg,REASON_EFFECT)
	local mg=c:GetMaterial() 
	if mg~=nil then  
	rg:Merge(mg)
	end
	c:SetMaterial(rg)
	end
end
function c79029465.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() and e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE) end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c79029465.spfilter(c,e,tp)
	return c:IsCode(79029010) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c79029465.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c79029465.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function c79029465.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029465.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
	Debug.Message("纠缠着我的噩梦啊，唱个歌吧。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029465,5))
	Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end









