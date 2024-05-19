--血腥蔷薇 占有欲
local s,id,o=GetID()
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(s.ttcon)
	e1:SetOperation(s.ttop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_LIMIT_SET_PROC)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,0))
	e4:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_HAND)
	e4:SetCondition(s.tdcon)
	e4:SetCost(s.tdcost)
	e4:SetTarget(s.tdtg)
	e4:SetOperation(s.tdop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetOperation(s.operation)
	c:RegisterEffect(e5)
end
function s.ttcon(e,c,minc)
	if c==nil then return true end
	return minc<=3 and Duel.CheckTribute(c,3)
end
function s.ttop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectTribute(tp,c,3,3)
	c:SetMaterial(g)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:GetActivateLocation()==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK) and re:GetHandler():IsSummonLocation(LOCATION_EXTRA)
end
function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST+REASON_DISCARD)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc:IsRelateToEffect(re) and rc:IsAbleToExtra() and rc:IsLocation(LOCATION_MZONE) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,rc,1,0,0)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
		and c:IsLocation(LOCATION_GRAVE)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local mg=rc:GetMaterial()
	local res=rc:IsSummonType(SUMMON_TYPE_FUSION) or rc:IsSummonType(TYPE_SYNCHRO) or rc:IsSummonType(TYPE_LINK)
	if rc:IsRelateToEffect(re) and Duel.SendtoDeck(rc,nil,SEQ_DECKTOP,REASON_EFFECT)~=0
		and res
		and rc:IsLocation(LOCATION_EXTRA) then
		local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		local tg=mg:Filter(aux.NecroValleyFilter(s.spfilter),nil,e,tp):Filter(Card.IsControler,nil,1-tp)
		if ft<=0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		local g=nil
		if tg:GetCount()>ft then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			g=tg:Select(tp,ft,ft,nil)
		else
			g=tg
		end
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,1-tp,false,false,POS_FACEUP)
		end
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(math.ceil(c:GetBaseAttack()/2))
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(math.ceil(c:GetBaseDefense()/2))
	c:RegisterEffect(e2)
end