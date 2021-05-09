--gathering of dragon palace
local m=11451417
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.operation2)
	c:RegisterEffect(e2)
end
function cm.spfilter(c,e,tp,mc)
	return c:IsRace(RACE_SEASERPENT) and bit.band(c:GetType(),0x81)==0x81 and (not c.mat_filter or c.mat_filter(mc)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and mc:IsCanBeRitualMaterial(c) and mc:IsLocation(LOCATION_MZONE) and mc:IsAttribute(ATTRIBUTE_WATER)
end
function cm.rfilter(c,mc)
	local mlv=mc:GetRitualLevel(c)
	if mlv==mc:GetLevel() then return false end
	local lv=c:GetLevel()
	return lv==bit.band(mlv,0xffff) or lv==bit.rshift(mlv,16)
end
function cm.filter(c,e,tp)
	local sg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,c,e,tp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)+1
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ts=Duel.GetTurnCount()
	ft=math.min(ft,ts)
	return sg:IsExists(cm.rfilter,1,nil,c) or sg:CheckWithSumEqual(Card.GetLevel,c:GetLevel(),1,ft)
end
function cm.mzfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<0 then return false end
		local mg=Duel.GetRitualMaterial(tp)
		mg=mg:Filter(cm.mzfilter,nil,tp)
		return mg:IsExists(cm.filter,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)+1
	if ft<0 then return end
	local mg=Duel.GetRitualMaterial(tp)
	mg=mg:Filter(cm.mzfilter,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mat=mg:FilterSelect(tp,cm.filter,1,1,nil,e,tp)
	local mc=mat:GetFirst()
	if not mc then return end
	local sg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,mc,e,tp,mc)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local ts=Duel.GetTurnCount()
	ft=math.min(ft,ts)
	local b1=sg:IsExists(cm.rfilter,1,nil,mc)
	local b2=sg:CheckWithSumEqual(Card.GetLevel,mc:GetLevel(),1,ft)
	if b1 and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(m,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:FilterSelect(tp,cm.rfilter,1,1,nil,mc)
		local tc=tg:GetFirst()
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CANNOT_ATTACK)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3,true)
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		tc:CompleteProcedure()
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetCountLimit(1)
		e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetLabelObject(tg)
		e4:SetCondition(cm.condition3)
		e4:SetOperation(cm.operation3)
		Duel.RegisterEffect(e4,tp)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:SelectWithSumEqual(tp,Card.GetLevel,mc:GetLevel(),1,ft)
		local tc=tg:GetFirst()
		while tc do
			tc:SetMaterial(mat)
			tc=tg:GetNext()
		end
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		tc=tg:GetFirst()
		local fid=e:GetHandler():GetFieldID()
		while tc do
			Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_CANNOT_ATTACK)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3,true)
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			tc:CompleteProcedure()
			tc=tg:GetNext()
		end
		tg:KeepAlive()
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetDescription(aux.Stringid(m,4))
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetCountLimit(1)
		e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetLabel(fid)
		e4:SetLabelObject(tg)
		e4:SetCondition(cm.condition3)
		e4:SetOperation(cm.operation3)
		Duel.RegisterEffect(e4,tp)
		Duel.SpecialSummonComplete()
	end
end
function cm.retfilter(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.condition3(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(cm.retfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function cm.operation3(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(cm.retfilter,nil,e:GetLabel())
	Duel.SendtoDeck(tg,nil,2,REASON_EFFECT)
end
function cm.drfilter(c)
	return c:IsFaceup() and bit.band(c:GetType(),0x81)==0x81 and c:IsSetCard(0x6978) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(cm.drfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct~=0 and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function cm.operation2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetMatchingGroupCount(cm.drfilter,p,LOCATION_MZONE,0,nil)
	Duel.Draw(p,ct,REASON_EFFECT)
end