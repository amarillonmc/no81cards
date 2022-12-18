local m=53750018
local cm=_G["c"..m]
cm.name="向异律的交涉者"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.costfilter(c)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_ONFIELD)) and c:GetType()==TYPE_SPELL and c:IsAbleToRemoveAsCost()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tc=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,c):GetFirst()
	Duel.Remove(Group.FromCards(c,tc),POS_FACEUP,REASON_COST)
	e:SetLabelObject(tc)
end
function cm.spfilter(c,e,tp)
	return c:IsRace(RACE_REPTILE) and c:IsLevel(8) and c:IsType(TYPE_EFFECT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local rc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if rc and Duel.SpecialSummon(rc,0,tp,tp,false,false,POS_FACEUP)~=0 and rc:IsLocation(LOCATION_MZONE) then
		local e1=Effect.CreateEffect(rc)
		e1:SetDescription(aux.Stringid(m,1))
		e1:SetType(EFFECT_TYPE_IGNITION)
		e1:SetRange(LOCATION_MZONE)
		e1:SetLabelObject(e:GetLabelObject())
		e1:SetCountLimit(1)
		e1:SetTarget(cm.actg)
		e1:SetOperation(cm.acop)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		rc:RegisterEffect(e1,true)
	end
end
function cm.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	local le={e:GetLabelObject():GetActivateEffect()}
	local check=false
	if chk==0 then
		e:SetCostCheck(false)
		for _,te in pairs(le) do
			local ftg=te:GetTarget()
			if (not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)) then check=true end
		end
		return check
	end
	local off=1
	local ops={}
	local opval={}
	for i,te in pairs(le) do
		local tg=te:GetTarget()
		e:SetCostCheck(false)
		if (not tg or tg(e,tp,eg,ep,ev,re,r,rp,0)) then
			local des=te:GetDescription()
			if des then ops[off]=des else ops[off]=aux.Stringid(m,2) end
			opval[off-1]=i
			off=off+1
		end
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local s=opval[op]
	e:SetLabel(s)
	local ae=le[s]
	local cat=ae:GetCategory()
	if cat then e:SetCategory(cat) else e:SetCategory(0) end
	e:SetProperty(ae:GetProperty())
	local etg=ae:GetTarget()
	if etg then
		e:SetCostCheck(false)
		etg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	local le={e:GetLabelObject():GetActivateEffect()}
	local ae=le[e:GetLabel()]
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end
