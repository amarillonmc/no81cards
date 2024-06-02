--双极生命·烈焰=琉璃
local cm,m,o=GetID()
cm.name = "双极生命·烈焰=琉璃"
function cm.initial_effect(c)
	--fusion material
	aux.AddCodeList(c,60002336,60002335)
	aux.AddFusionProcCode2(c,60002336,60002335,true,true)
	--attribute
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(0xff)
	e1:SetValue(ATTRIBUTE_FIRE)
	c:RegisterEffect(e1)
	--fusion type
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetRange(0xff)
	e1:SetValue(TYPE_FUSION)
	c:RegisterEffect(e1)
	--sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetTarget(cm.tgtg)
	e1:SetOperation(cm.tgop)
	c:RegisterEffect(e1)
	--grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60001173,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.hstg)
	e2:SetOperation(cm.hsop)
	c:RegisterEffect(e2)
end
cm.is_fusion=true
if not changefusion then
	changefusion=true
	cm.is_type=Card.IsType
	Card.IsType=function(car,typ,...)
		if typ&TYPE_FUSION>0 then
			return cm.is_type(car,typ,...) or car.is_fusion
		else
			return cm.is_type(car,typ,...)
		end
	end
end
function cm.afil1(c)
	return (c:IsCode(60002335) or c:IsCode(60002336)) and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(cm.afil1,tp,LOCATION_HAND,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.afil1,tp,LOCATION_HAND,0,1,99,nil)
		Duel.SendtoGrave(g,REASON_EFFECT)
		local qs=0
		for i=1,#g do
			local kt=g:GetFirst()
			if kt:IsLocation(LOCATION_GRAVE) then
				qs=qs+1
			end
			g:RemoveCard(kt)
		end
		if qs>=1 then
			local sg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
			Duel.Destroy(sg,REASON_EFFECT)
			if qs>=2 then
				Duel.Draw(tp,2,REASON_EFFECT)
			end
		end
	end
end
function cm.afil2(c)
	return aux.IsCodeListed(c,60002336) and aux.IsCodeListed(c,60002335) and c:IsAbleToHand()
end
function cm.hstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(cm.afil1,tp,LOCATION_DECK,0,nil)
	if chk==0 then return e:GetHandler():IsAbleToDeck() and g1:GetClassCount(Card.GetCode)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function cm.hsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ua=Duel.GetMatchingGroup(cm.afil1,tp,LOCATION_DECK,0,nil):GetClassCount(Card.GetCode)
	local ub=Duel.GetMatchingGroup(cm.afil2,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil):GetCount()
	if c:IsRelateToEffect(e) then
		if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
			
				local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,60002336)
				Duel.SendtoGrave(g:GetFirst(),REASON_EFFECT)
				local gg=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,0,nil,60002335)
				Duel.SendtoGrave(gg:GetFirst(),REASON_EFFECT)
		   
		end
	end
end