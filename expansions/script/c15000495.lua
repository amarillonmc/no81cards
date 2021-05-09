local m=15000495
local cm=_G["c"..m]
cm.name="星拟龙·坍缩子龙 RK3"
function cm.initial_effect(c)
	aux.AddCodeList(c,15000496)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
--	local e2=Effect.CreateEffect(c)
--	e2:SetType(EFFECT_TYPE_FIELD)
--	e2:SetCode(EFFECT_SPSUMMON_PROC)
--	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
--	e2:SetRange(LOCATION_EXTRA)
--	e2:SetCondition(cm.RkXyzCondition(cm.sprfilter,nil,cm.sprop))
--	e2:SetTarget(cm.RkXyzTarget(cm.sprfilter,nil,cm.sprop))
--	e2:SetOperation(cm.RkXyzOperation(cm.sprfilter,nil,cm.sprop))
--	c:RegisterEffect(e2)
	--rk up
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.sp2con)
	e3:SetTarget(cm.sp2tg)
	e3:SetOperation(cm.sp2op)
	c:RegisterEffect(e3)
	--get effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.condition)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--immune
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(cm.econ)
	e5:SetValue(cm.efilter)
	c:RegisterEffect(e5)
end
cm.rkup={15000496}
function cm.condition(e)
	return e:GetHandler():GetOriginalAttribute()==ATTRIBUTE_DARK
end
function cm.econ(e)
	return e:GetHandler():GetOriginalAttribute()==ATTRIBUTE_DARK and Duel.GetCurrentPhase()==PHASE_END
end
function cm.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function cm.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function cm.sprfilter(c)
	return c:IsFaceup() and c:IsCanOverlay() and c:IsType(TYPE_LINK) and c:IsLink(1,2) and ((c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON)) or c:IsSetCard(0xf34))
end
function cm.RkXyzFilter(c,alterf,xyzc,e,tp,op)
	return alterf(c) and c:IsCanBeXyzMaterial(xyzc) and Duel.GetLocationCountFromEx(tp,tp,c,xyzc)>0 and Auxiliary.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and (not op or op(e,tp,0,c))
end
function cm.RkXyzCondition(alterf,desc,op)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				if (not min or min<=1) and mg:IsExists(cm.RkXyzFilter,1,nil,alterf,c,e,tp,op) then
					return true
				end
			end
end
function cm.RkXyzTarget(alterf,desc,op)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				local b2=(not min or min<=1) and mg:IsExists(cm.RkXyzFilter,1,nil,alterf,c,e,tp,op)
				local g=nil
				if b2 then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					g=mg:FilterSelect(tp,cm.RkXyzFilter,1,1,nil,alterf,c,e,tp,op)
					if op then op(e,tp,1,g:GetFirst()) end
				end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function cm.RkXyzOperation(alterf,desc,op)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				local mg=e:GetLabelObject()
				local mg2=mg:GetFirst():GetOverlayGroup()
				if mg2:GetCount()~=0 then
					Duel.Overlay(c,mg2)
				end
				c:SetMaterial(mg)
				Duel.Overlay(c,mg)
				mg:DeleteGroup()
			end
end
function cm.sprop(e,tp,chk,tc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sprfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.spfilter(c,att,rac,rk,e,tp,sc)
	return (c:IsSetCard(0x3f34) or c:IsSetCard(0x9f38)) and c:GetRank()>rk and c:GetRank()<=rk+3 and c:IsAttribute(att) and c:IsRace(rac) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,sc,c)>0 and sc:IsCanOverlay(c)
end
function cm.sp2filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRankBelow(5)
end
function cm.sp2con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return c:IsCanOverlay() and not Duel.IsExistingMatchingCard(cm.sp2filter,tp,LOCATION_MZONE,0,1,c)
end
function cm.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,c:GetAttribute(),c:GetRace(),c:GetRank(),e,tp,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.sp2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,c:GetAttribute(),c:GetRace(),c:GetRank(),e,tp,c)
	local tc=g:GetFirst()
	if tc then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(tc,mg)
		end
		tc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(tc,Group.FromCards(c))
		if Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)~=0 then
			if tc:GetOriginalCodeRule()==15000496 then tc:CompleteProcedure() end
			if not tc:GetOriginalCodeRule()==15000496 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
			end
			Duel.SpecialSummonComplete()
		end
	end
end