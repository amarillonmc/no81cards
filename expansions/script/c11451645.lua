--救祓少女·埃莉亚忒
--21.12.31
local cm,m=GetID()
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,4,3)
	c:EnableReviveLimit()
	--remove
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCondition(cm.effcon)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x172))
	e3:SetValue(cm.atkval)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetDescription(aux.Stringid(m,0))
		ge0:SetCategory(CATEGORY_SPECIAL_SUMMON)
		ge0:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_EVENT_PLAYER)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		ge0:SetCode(EVENT_LEAVE_GRAVE)
		ge0:SetCondition(cm.spcon)
		ge0:SetTarget(cm.sptg)
		ge0:SetOperation(cm.spop)
		--Duel.RegisterEffect(ge0,0)
	end
end
function cm.effcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetLabel()==1
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_DELAY)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_LEAVE_GRAVE)
	e0:SetCondition(cm.spcon)
	e0:SetTarget(cm.sptg)
	e0:SetOperation(cm.spop)
	--Duel.RegisterEffect(e0,tp)
	local e4=e0:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_F)
	e4:SetCondition(cm.spcon3)
	--Duel.RegisterEffect(e4,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_GRAVE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(cm.spcon2)
	e2:SetTarget(cm.sptg2)
	e2:SetOperation(cm.spop2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(cm.eftg)
	e3:SetLabelObject(e2)
	Duel.RegisterEffect(e3,tp)
end
function cm.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0x172)
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0x172) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function cm.atkfilter(c)
	return c:IsSummonLocation(LOCATION_GRAVE)
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.atkfilter,c:GetControler(),0,LOCATION_MZONE,nil)*800
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and Duel.GetFlagEffect(tp,m)>0
end
function cm.spcon3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ((c:IsLocation(LOCATION_ONFIELD+LOCATION_REMOVED) and c:IsFacedown()) or c:GetOverlayTarget() or eg:IsContains(c)) and cm.spcon(e,tp,eg,ep,ev,re,r,rp)
end
function cm.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x172) and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL)
end
function cm.filter2(c,e,tp,mc)
	return c:IsSetCard(0x172) and c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	e:GetHandler():ClearEffectRelation()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	if g and #g>0 then
		local mc=g:GetFirst()
		local sg=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mc)
		local sc=sg:GetFirst()
		if sc then
			local mg=mc:GetOverlayGroup()
			if #mg>0 then Duel.Overlay(sc,mg) end
			sc:SetMaterial(Group.FromCards(mc))
			Duel.Overlay(sc,mc)
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.spfilter(c,e,tp,mc)
	return c:IsSetCard(0x172) and c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_OPSELECTED,tp,e:GetDescription())
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) and not c:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
		local sc=g:GetFirst()
		if sc then
			local mg=c:GetOverlayGroup()
			if mg:GetCount()~=0 then
				Duel.Overlay(sc,mg)
			end
			sc:SetMaterial(Group.FromCards(c))
			Duel.Overlay(sc,Group.FromCards(c))
			Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
			sc:CompleteProcedure()
		end
	end
end
function cm.xyzfilter(c)
	return c:IsXyzSummonable(nil) and c:IsSetCard(0x172)
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end