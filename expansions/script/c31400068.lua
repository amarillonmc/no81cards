local m=31400068
local cm=_G["c"..m]
cm.name="神碑之王战 洛普特"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,m)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x134),2,true)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.drcon)
	e1:SetTarget(cm.drtg)
	e1:SetOperation(cm.drop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.spcon1)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone() 
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(cm.spcon2)
	c:RegisterEffect(e4)
	if not cm.hack then
		cm.hack=true
		local e=Effect.CreateEffect(c)
		e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e:SetOperation(cm.hack_op)
		e:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
		Duel.RegisterEffect(e,0)
	end
end
function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonLocation(LOCATION_EXTRA)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and g and g:FilterCount(aux.TRUE,e:GetHandler())>0 and Duel.IsChainDisablable(ev) and not Duel.IsChainDisabled(ev) then
		Duel.NegateEffect(ev)
	end
end
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsActivated() and re:IsActiveType(TYPE_MONSTER)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x17f,0x134) and not c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function cm.hack_op(e,tp,eg,ep,ev,re,r,rp)
	Duel.CreateToken(tp,38053381)
	local c38053381=_G["c38053381"]
	c38053381.tkop=cm.tkop_38053381
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
	g:ForEach(
		function (tc)
			if tc:IsCode(38053381) then Card.ReplaceEffect(tc,38053381,nil) end
		end
	)
end
function cm.tkop_spfilter(c,e,tp)
	return c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.tkop_38053381(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,38053382,0x134,TYPES_TOKEN_MONSTER,1500,1500,4,RACE_FAIRY,ATTRIBUTE_LIGHT,POS_FACEUP_ATTACK) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local spg=Duel.GetMatchingGroup(cm.tkop_spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if ft>=2 and #spg>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		ft=ft-2
		local tc=spg:Select(tp,1,1,nil):GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
	if ft==0 then return end
	local fid=e:GetHandler():GetFieldID()
	local g=Group.CreateGroup()
	for i=1,ft do
		local token=Duel.CreateToken(tp,38053382)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
		token:RegisterFlagEffect(38053381,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		g:AddCard(token)
	end
	Duel.SpecialSummonComplete()
	g:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(g)
	e1:SetCondition(c38053381.descon)
	e1:SetOperation(c38053381.desop)
	Duel.RegisterEffect(e1,tp)
end