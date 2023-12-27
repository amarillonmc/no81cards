local m=53799116
local cm=_G["c"..m]
cm.name="月下的奏者·HNS RK7"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddCodeList(c,m+1)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_DRAW_PHASE+TIMING_DRAW+TIMING_TOHAND+TIMING_END_PHASE)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.rmcost)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
	local sg=Group.CreateGroup()
	sg:KeepAlive()
	e3:SetLabelObject(sg)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.spcon)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	e4:SetLabelObject(sg)
	c:RegisterEffect(e4)
end
cm.rkup={m+1}
cm.rkdn={m-1}
function cm.cfilter(c)
	return not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(REASON_COST,tp,cm.cfilter,1,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(REASON_COST,tp,cm.cfilter,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function cm.rmfilter(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(cm.rmfilter,1-tp,LOCATION_MZONE,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_MZONE)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.rmfilter,1-tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
		local tc=g:Select(1-tp,1,1,nil):GetFirst()
		if tc and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_REMOVED) and c:IsRelateToEffect(e) then
			local sg=e:GetLabelObject()
			if c:GetFlagEffect(m)==0 then
				sg:Clear()
				c:RegisterFlagEffect(m,RESET_EVENT+0x1680000,0,1)
			end
			sg:AddCard(tc)
			tc:CreateRelation(c,RESET_EVENT+RESETS_STANDARD)
		end
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function cm.spfilter(c,e,tp,mc)
	return c:IsCode(m+1) and c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and aux.MustMaterialCheck(e:GetHandler(),tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spfilter2(c,rc,e,tp)
	return c:IsRelateToCard(rc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
	local tc=g:GetFirst()
	if tc then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(tc,mg)
		end
		tc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(tc,Group.FromCards(c))
		if Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)~=0 then
			tc:CompleteProcedure()
			Duel.SpecialSummonComplete()
			local rmg=e:GetLabelObject()
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			local tg=rmg:Filter(cm.spfilter2,nil,c,e,tp)
			if ft>0 and tg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				Duel.BreakEffect()
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=tg:Select(tp,ft,ft,nil)
				for spc in aux.Next(sg) do
					Duel.SpecialSummonStep(spc,0,tp,tp,false,false,POS_FACEUP)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					spc:RegisterEffect(e1)
					local e2=Effect.CreateEffect(c)
					e2:SetType(EFFECT_TYPE_SINGLE)
					e2:SetCode(EFFECT_DISABLE_EFFECT)
					e2:SetReset(RESET_EVENT+RESETS_STANDARD)
					spc:RegisterEffect(e2)
					Duel.SpecialSummonComplete()
					spc:CompleteProcedure()
				end
			end
		end
	end
end
