local m=15006364
local cm=_G["c"..m]
cm.name="折折界的神隐折"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
	--Destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	c:RegisterEffect(e2)
end
function cm.rmfilter1(c)
	return c:IsSetCard(0x5f45) and c:IsFaceupEx() and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function cm.rmfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter1,tp,LOCATION_MZONE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_MZONE+LOCATION_DECK)
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rg=Duel.SelectMatchingCard(tp,cm.rmfilter1,tp,LOCATION_MZONE+LOCATION_DECK,0,1,1,nil)
	local rrg=Group.CreateGroup()
	if Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)~=0 then
		local rsg=Duel.GetOperatedGroup()
		local cv=rsg:GetFirst():GetFieldID()
		rsg:GetFirst():RegisterFlagEffect(15006364,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,cv)
		rrg:Merge(rsg)
		if rsg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_MZONE) and Duel.IsExistingMatchingCard(cm.rmfilter2,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local og=Duel.SelectMatchingCard(tp,cm.rmfilter2,tp,0,LOCATION_MZONE,1,1,nil)
			if #og>0 then
				Duel.BreakEffect()
				if Duel.Remove(og,POS_FACEUP,REASON_EFFECT)~=0 then
					local rog=Duel.GetOperatedGroup()
					rog:GetFirst():RegisterFlagEffect(15006364,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1,cv)
					rrg:Merge(rog)
				end
			end
		end
		rrg:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,0))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1,m+1)
		e1:SetLabelObject(rrg)
		e1:SetLabel(cv)
		e1:SetTarget(cm.sptg)
		e1:SetOperation(cm.spop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_CHANGE_POS)
		e2:SetCondition(cm.spcon)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,tp)
end
function cm.spfilter(c,e,tp,cv)
	return c:IsType(TYPE_MONSTER) and c:GetFlagEffect(15006364)~=0 and c:GetFlagEffectLabel(15006364)==cv and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE) and Duel.GetMZoneCount(c:GetOwner())>0
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local rrg=e:GetLabelObject()
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,rrg,#rrg,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local cv=e:GetLabel()
	local rrg=e:GetLabelObject()
	if not rrg then return end
	local og=rrg:Filter(cm.spfilter,nil,e,tp,cv)
		if #og<=0 then return end
		local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
		if ft1<=0 and ft2<=0 then return end
		local spg=Group.CreateGroup()
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then
			if ft1>0 and ft2>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				spg=og:Select(tp,1,1,nil)
			else
				local p
				if ft1>0 and ft2<=0 then
					p=tp
				end
				if ft1<=0 and ft2>0 then
					p=1-tp
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				spg=og:FilterSelect(tp,Card.IsControler,1,1,nil,p)
			end
		else
			local p=tp
			for i=1,2 do
				local sg=og:Filter(Card.IsControler,nil,p)
				local ft=Duel.GetLocationCount(p,LOCATION_MZONE,tp)
				if #sg>ft then
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
					sg=sg:Select(tp,ft,ft,nil)
				end
				spg:Merge(sg)
				p=1-tp
			end
		end
		if #spg>0 then
			local tc=spg:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,tp,tc:GetControler(),false,false,POS_FACEUP+POS_FACEDOWN_DEFENSE)
				tc=spg:GetNext()
			end
			Duel.SpecialSummonComplete()
			local cg=spg:Filter(Card.IsFacedown,nil)
			if #cg>0 then
				Duel.ConfirmCards(1-tp,cg)
			end
		end
end
function cm.repfilter(c,tp)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and c:IsFaceup() and c:IsSetCard(0x5f45)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(cm.repfilter,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
		return true
	else return false end
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end