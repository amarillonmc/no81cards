local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(id)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(s.sprcon)
	e2:SetTarget(s.sprtg)
	e2:SetOperation(s.sprop)
	e2:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e4)
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,id,{EVENT_SUMMON_SUCCESS,EVENT_SPSUMMON_SUCCESS})
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(custom_code)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.trcon)
	e5:SetOperation(s.trop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER+CATEGORY_TOHAND+CATEGORY_EQUIP)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_PHASE+PHASE_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetTarget(s.tdtg)
	e6:SetOperation(s.tdop)
	c:RegisterEffect(e6)
	if not s.global_check then
		s.global_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_ADJUST)
		ge0:SetOperation(s.geop)
		Duel.RegisterEffect(ge0,0)
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ADJUST)
		ge1:SetOperation(s.adjust)
		Duel.RegisterEffect(ge1,0)
		Duel.RegisterFlagEffect(0,id,0,0,0,0)
		Duel.RegisterFlagEffect(1,id,0,0,0,0)
		s.OAe={}
	end
end
function s.splimit(e,se,sp,st)
	return e:GetHandler():GetFlagEffect(id)>0-- and Duel.GetTurnPlayer()~=sp
end
function s.xyzfilter(c,xyzc)
	return c:IsFaceup() and c:IsAllTypes(0x20004) and c:IsCanOverlay()
end
function s.sprcon(e,c,og,min,max)
	if c==nil then return true end
	if c:GetFlagEffect(id)==0 then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_REMOVED,0,nil,c)
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	if sg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
	Duel.SetSelectedCard(sg)
	aux.GCheckAdditional=aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	local res=mg:CheckSubGroup(aux.TRUE,1,#mg)
	aux.GCheckAdditional=nil
	return res
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local mg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_REMOVED,0,nil,c)
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	Duel.SetSelectedCard(sg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	aux.GCheckAdditional=aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
	local g=mg:SelectSubGroup(tp,aux.TRUE,true,1,#mg)
	aux.GCheckAdditional=nil
	if g and g:GetCount()>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local mg=e:GetLabelObject()
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	mg:DeleteGroup()
end
function s.trcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler())
end
function s.trop(e,tp,eg,ep,ev,re,r,rp)
	local ct0=Duel.GetFlagEffectLabel(0,id)
	local ct1=Duel.GetFlagEffectLabel(1,id)
	Duel.SetFlagEffectLabel(0,id,ct0+1)
	Duel.SetFlagEffectLabel(1,id,ct1+1)
	Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+id+50,re,r,rp,ep,ev)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	local ct=c:GetOverlayCount()
	if ct>0 then
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*1500)
	end
end
function s.thfilter(c)
	return c:IsFaceupEx() and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function s.eqfilter(c,tc)
	return c:IsFaceupEx() and c:CheckEquipTarget(tc)
end
function s.eqdfilter(c,tp)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,c)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ct=c:GetOverlayCount()
	if Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_EFFECT)<1 or ct<1 then return end
	if Duel.Recover(tp,ct*1500,REASON_EFFECT)<=0 then return end
	local th=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local eq=ft>0 and Duel.IsExistingMatchingCard(s.eqdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
	local op=0
	if th and eq then op=Duel.SelectOption(tp,1190,aux.Stringid(id,1))
	elseif th then op=0
	elseif eq then op=1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local thg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,ct,nil)
		Duel.SendtoHand(thg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,thg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local eqdg=Duel.SelectMatchingCard(tp,s.eqdfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,ct,nil,tp)
		Duel.HintSelection(eqdg)
		local eqg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.eqfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,math.min(ct,ft),nil,eqdg:GetFirst())
		for eqc in aux.Next(eqg) do Duel.Equip(tp,eqc,eqdg:GetFirst(),true,true) end
		Duel.EquipComplete()
	end
end
function s.geop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(function(c)return c:IsType(TYPE_QUICKPLAY) and c:GetActivateEffect()end,0,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	for tc in aux.Next(g) do
		local le={tc:GetActivateEffect()}
		for i,v in pairs(le) do
			if v:IsHasRange(0xa) and not SNNM.IsInTable(v,s.OAe) then
				table.insert(s.OAe,v)
				local e1=v:Clone()
				if not v:GetDescription() then e1:SetDescription(aux.Stringid(id,2)) end
				e1:SetRange(LOCATION_GRAVE)
				tc:RegisterEffect(e1,true)
				local e2=SNNM.Act(tc,e1)
				e2:SetRange(LOCATION_GRAVE)
				e2:SetCost(s.costchk)
				e2:SetOperation(s.costop)
				tc:RegisterEffect(e2,true)
			end
		end
	end
end
function s.sfilter(c,tp)
	return c:IsHasEffect(id) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end
function s.costchk(e,te_or_c,tp)
	local ct=Duel.GetFlagEffectLabel(tp,id)
	return ct>0 and Duel.CheckEvent(EVENT_CUSTOM+id+50) and Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEATTACHFROM)
	local tc=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_MZONE,0,1,1,nil,tp):GetFirst()
	tc:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	local ct=Duel.GetFlagEffectLabel(tp,id)
	Duel.SetFlagEffectLabel(tp,id,ct-1)
	SNNM.BaseActOp(e,tp,eg,ep,ev,re,r,rp)
end
function s.adjust(e,tp,eg,ep,ev,re,r,rp)
	if Duel.CheckEvent(EVENT_CUSTOM+id+50) then return end
	Duel.SetFlagEffectLabel(0,id,0)
	Duel.SetFlagEffectLabel(1,id,0)
end
