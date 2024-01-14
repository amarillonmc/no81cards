--升阶魔法-Kamipro 欧克的指引
function c50214125.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,50214125)
	e1:SetCost(c50214125.cost)
	e1:SetTarget(c50214125.target)
	e1:SetOperation(c50214125.activate)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,50214125)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c50214125.rmtg)
	e2:SetOperation(c50214125.rmop)
	c:RegisterEffect(e2)
end
function c50214125.cgfilter(c)
	return c:IsSetCard(0xcbf) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c50214125.cefilter(c,tc,ct,e,tp)
	if not c:IsType(TYPE_XYZ) then return false end
	local r=c:GetRank()-tc:GetRank()
	return c:IsSetCard(0xcbf)
		and tc:IsCanBeXyzMaterial(c) and r>0 and ct>=r
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c50214125.cfilter(c,e,tp)
	local ct=Duel.GetMatchingGroupCount(c50214125.cgfilter,tp,LOCATION_GRAVE,0,nil)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xcbf) and c:IsFaceup()
		and c:IsCanBeEffectTarget(e)
		and Duel.IsExistingMatchingCard(c50214125.cefilter,tp,LOCATION_EXTRA,0,1,nil,c,ct,e,tp)
end
function c50214125.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c50214125.tgefilter(c,tc,e,tp,rank)
	if not c:IsType(TYPE_XYZ) then return false end
	local r=c:GetRank()-tc:GetRank()
	return c:IsSetCard(0xcbf)
		and tc:IsCanBeXyzMaterial(c) and r==rank
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,tc,c)>0
end
function c50214125.tgfilter(c,e,tp,rank)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0xcbf)
		and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c50214125.tgefilter,tp,LOCATION_EXTRA,0,1,nil,c,e,tp,rank)
end
function c50214125.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c50214125.cfilter(chkc,e,tp) end
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingTarget(c50214125.cfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	e:SetLabel(0)
	local avail={}
	local availbool={}
	local ct=Duel.GetMatchingGroupCount(c50214125.cgfilter,tp,LOCATION_GRAVE,0,nil)
	local gfield=Duel.GetMatchingGroup(c50214125.cfilter,tp,LOCATION_MZONE,0,nil,e,tp)
	for tc in aux.Next(gfield) do
		local gextra=Duel.GetMatchingGroup(c50214125.cefilter,tp,LOCATION_EXTRA,0,nil,tc,ct,e,tp)
		for ex in aux.Next(gextra) do
			local r=ex:GetRank()-tc:GetRank()
			if not availbool[r] then
				availbool[r]=true
				table.insert(avail,r)
			end
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(50214125,0))
	local num=Duel.AnnounceNumber(tp,table.unpack(avail))
	e:SetLabel(num)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local cost=Duel.SelectMatchingCard(tp,c50214125.cgfilter,tp,LOCATION_GRAVE,0,num,num,nil)
	Duel.Remove(cost,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c50214125.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,num)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c50214125.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if aux.MustMaterialCheck(tc,tp,EFFECT_MUST_BE_XMATERIAL) and tc:IsFaceup()
		and tc:IsRelateToEffect(e) and tc:IsControler(tp) and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c50214125.tgefilter,tp,LOCATION_EXTRA,0,1,1,nil,tc,e,tp,e:GetLabel())
		local sc=g:GetFirst()
		if sc then
			local mg=tc:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(tc))
			Duel.Overlay(sc,Group.FromCards(tc))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end
function c50214125.rmfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup() and c:IsAbleToRemove()
end
function c50214125.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c50214125.rmfilter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c50214125.rmfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c50214125.rmfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c50214125.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end