--灵影神精 巴御前
function c40009399.initial_effect(c)
	c:SetSPSummonOnce(40009399)
	--xyz summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local zone=Duel.GetFieldGroup(tp,LOCATION_MZONE+LOCATION_SZONE,0)
				local minc=2
				local maxc=zone:GetCount()
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				return Duel.CheckXyzMaterial(c,c40009399.xyzfilter,8,minc,maxc,zone)
			end)
	e0:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local zone=Duel.GetFieldGroup(tp,LOCATION_MZONE+LOCATION_SZONE,0)
				local minc=2
				local maxc=zone:GetCount() 
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local g=Duel.SelectXyzMaterial(tp,c,c40009399.xyzfilter,8,minc,maxc,zone)
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end)
	e0:SetOperation(function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					local sg=Group.CreateGroup()
					local tc=mg:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=mg:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0) 
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009399,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCost(c40009399.descost)
	e1:SetTarget(c40009399.destg)
	e1:SetOperation(c40009399.desop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009399,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c40009399.spcon)
	e2:SetTarget(c40009399.sptg)
	e2:SetOperation(c40009399.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e3)
  
end
function c40009399.xyzfilter(c)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_MZONE))
		and (c:IsSetCard(0x1f1d) or not c:IsLocation(LOCATION_SZONE))
end
function c40009399.desfilter(c)
	return c:IsSetCard(0x1f1d) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())  and c:IsAbleToRemoveAsCost()
end
function c40009399.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) and Duel.IsExistingMatchingCard(c40009399.desfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c40009399.desfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c40009399.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c40009399.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c40009399.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD) 
end
function c40009399.spfilter(c,e,tp)
	return c:IsCode(40009223) and (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_DECK) or c:IsFaceup()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009399.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40009399.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK+LOCATION_HAND)
end
function c40009399.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40009399.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

