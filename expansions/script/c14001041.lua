--罔骸神 心骸星
local m=14001041
local cm=_G["c"..m]
if not Goned then
	Goned=Goned or {}
	go=Goned
	function go.effect(c)
		local code=c:GetOriginalCodeRule()
		c:SetSPSummonOnce(code)
		--special summon from hand
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(code,0))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SPSUMMON_PROC)
		e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
		e1:SetRange(LOCATION_HAND)
		e1:SetCondition(go.spcon)
		e1:SetOperation(go.spop)
		c:RegisterEffect(e1)
		--special summon while decked
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(code,1))
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
		e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e2:SetProperty(EFFECT_FLAG_DELAY)
		e2:SetCode(EVENT_TO_GRAVE)
		e2:SetCondition(go.spcon1)
		e2:SetTarget(go.sptg1)
		e2:SetOperation(go.spop1)
		c:RegisterEffect(e2)
	end
	function go.spcon(e,c)
		if c==nil then return true end
		local tp=c:GetControler()
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,c)
	end
	function go.spop(e,tp,eg,ep,ev,re,r,rp,c)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,c)
		Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	end
	function go.spcon1(e,tp,eg,ep,ev,re,r,rp)
		return e:GetHandler():GetPreviousLocation()==LOCATION_DECK
	end
	function go.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	end
	function go.spop1(e,tp,eg,ep,ev,re,r,rp)
		if e:GetHandler():IsRelateToEffect(e) then
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
	function go.named(c)
		local m=_G["c"..c:GetCode()]
		return m and m.named_with_Goned
	end
end
--selfeffects
if cm then
	cm.named_with_Goned=1
	function cm.initial_effect(c)
		--goeffects
		go.effect(c)
	end
end