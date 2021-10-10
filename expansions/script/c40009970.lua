--究极兽神 穷奇·灾变
local m=40009970
local cm=_G["c"..m]
cm.named_with_BeastDeity=1
function cm.BeastDeity(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_BeastDeity
end

function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(cm.BeastDeity),8,3,cm.ovfilter,aux.Stringid(m,0),99,cm.xyzop)
	c:EnableReviveLimit()
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[1]=0
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge4:SetOperation(cm.clearop)
		Duel.RegisterEffect(ge4,0)
	end
	--copy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.copycost)
	e2:SetTarget(cm.copytg)
	e2:SetOperation(cm.copyop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_DAMAGE_STEP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(cm.spcost)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetAttacker()~=nil and cm.BeastDeity(Duel.GetAttacker()) then
		local pl=Duel.GetAttacker():GetControler()
		if pl then
			cm[pl]=cm[pl]+1
		end
	end
	if Duel.GetAttackTarget()~=nil and cm.BeastDeity(Duel.GetAttackTarget()) then
		local pl=Duel.GetAttackTarget():GetControler()
		if pl then
			cm[pl]=cm[pl]+1
		end
	end
end
function cm.clearop(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
function cm.ovfilter(c)
	return c:IsFaceup() and cm.BeastDeity(c) and c:IsType(TYPE_XYZ)
end
function cm.filter(c)
	return c:IsCode(m) and c:IsType(TYPE_MONSTER)
		 and c:IsAbleToRemove()
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m+1)==0 and cm[tp]>0 end
	Duel.RegisterFlagEffect(tp,m+1,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function cm.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.cpfilter(c)
	return cm.BeastDeity(c) and not c:IsForbidden() and not c:IsCode(m)
end
function cm.copytg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup():Filter(cm.cpfilter,nil)
	if chk==0 then return g:GetCount()>0 end
end
function cm.copyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup():Filter(cm.cpfilter,nil)
	if g:GetCount()>0 and c:IsRelateToEffect(e) and c:IsFaceup() then
		local tc=g:GetFirst()
		local array={}
		while tc do
			local code=tc:GetOriginalCode()
			local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,1)
			array[#array+1]=cid
			tc=g:GetNext()
		end
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,1))
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e2:SetCountLimit(1)
		e2:SetRange(LOCATION_MZONE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e2:SetLabel(table.unpack(array))
		e2:SetOperation(cm.rstop)
		c:RegisterEffect(e2)
	end
end
function cm.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local array={e:GetLabel()}
	for _,ct in pairs(array) do
		c:ResetEffect(ct,RESET_COPY)
		c:ResetEffect(RESET_DISABLE,RESET_EVENT)
	end
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and aux.dscon() and Duel.GetTurnPlayer()==tp and (e:GetHandler():GetBattledGroupCount()>0 or e:GetHandler():GetAttackedCount()>0)
end
function cm.cfilter(c)
	return c:IsCode(m) and c:IsFaceup()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToGraveAsCost,tp,LOCATION_MZONE,0,c)
	if chk==0 then return c:IsPosition(POS_FACEUP_ATTACK) and g:GetCount()>0 and  Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup():Filter(cm.spfilter,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and og:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_OVERLAY)
end
function cm.spfilter(c,e,tp)
	return cm.BeastDeity(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local tg=c:GetOverlayGroup():Filter(cm.spfilter,nil,e,tp)
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
		local fid=e:GetHandler():GetFieldID()
		local tc=g:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_UPDATE_ATTACK)
			e4:SetValue(800)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e4,true)
			tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
		c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,fid)
		g:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabel(fid)
		e1:SetLabelObject(g)
		e1:SetCondition(cm.ovcon)
		e1:SetOperation(cm.ovop)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.ovfilter2(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.ovcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local g=e:GetLabelObject()
	if not c:GetFlagEffectLabel(m)==fid and not g:IsExists(cm.ovfilter2,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local g=e:GetLabelObject()
	local tg=g:Filter(cm.ovfilter2,nil,e:GetLabel())
	g:DeleteGroup()
	Duel.Overlay(c,tg)
end
