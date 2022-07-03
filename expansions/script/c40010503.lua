--朱斯贝克·反抗黎骑
local m=40010503
local cm=_G["c"..m]
cm.named_with_Rebellionform=1
function cm.initial_effect(c)
	aux.AddCodeList(c,40010501)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,3)
	c:EnableReviveLimit()   
	--tograve
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.atkcon)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1) 
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.xyzcon)
	e2:SetTarget(cm.xyztg)
	e2:SetOperation(cm.xyzop)
	c:RegisterEffect(e2)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(cm.cfliter,1,nil,rp) then
		Duel.RegisterFlagEffect(rp,m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.cfliter(c)
	return c:IsCode(40010501) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,40010501)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(3000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if Duel.GetFlagEffect(tp,m)>1 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_EXTRA_ATTACK)
			e2:SetValue(1)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e2)
		end
	end
end
function cm.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,40010501)
end
function cm.toexfilter(c,tp)
	return c:IsCode(40010501) and c:IsType(TYPE_XYZ) and c:IsAbleToExtra() and c:GetOwner()==tp
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if chk==0 then return c:GetFlagEffect(m+1)==0 and g:IsExists(cm.toexfilter,1,nil,tp) end
	c:RegisterFlagEffect(m+1,RESET_CHAIN,0,1)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sc=g:FilterSelect(tp,cm.toexfilter,1,1,nil,tp):GetFirst()
		if sc and Duel.SendtoDeck(sc,nil,0,REASON_EFFECT)>0 and sc:IsLocation(LOCATION_EXTRA)
			and c:IsFaceup() and c:IsControler(tp) and not c:IsImmuneToEffect(e)
			and aux.MustMaterialCheck(c,tp,EFFECT_MUST_BE_XMATERIAL) and c:IsCanBeXyzMaterial(sc)
			and sc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 then
			Duel.BreakEffect()
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
