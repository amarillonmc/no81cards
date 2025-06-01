local m=75000057
local cm=_G["c"..m]
cm.name="「烈火」纹章士-“草原女爵”"
function cm.initial_effect(c)
	aux.AddCodeList(c,75000001)
	--link summon
	aux.AddLinkProcedure(c,nil,2,nil,cm.lcheck)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.tkcon)
	e1:SetTarget(cm.tktg)
	e1:SetOperation(cm.tkop)
	c:RegisterEffect(e1)
	--Damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.damcon)
	e2:SetTarget(cm.damtg)
	e2:SetOperation(cm.damop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.tgtg)
	e3:SetOperation(cm.tgop)
	c:RegisterEffect(e3)
end
function cm.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==g:GetCount()
end
function cm.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,75000059,0,TYPES_TOKEN_MONSTER,0,0,4,RACE_CYBERSE,ATTRIBUTE_WIND) end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,ft,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ft,0,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,75000059,0,TYPES_TOKEN_MONSTER,0,0,4,RACE_CYBERSE,ATTRIBUTE_WIND) then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local fid=e:GetHandler():GetFieldID()
	local g=Group.CreateGroup()
	for i=1,ft do
		local token=Duel.CreateToken(tp,75000059)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		token:RegisterFlagEffect(75000057,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2,fid)
		g:AddCard(token)
		--no battle damage
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_NO_BATTLE_DAMAGE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		e3:SetValue(1)
		token:RegisterEffect(e3)
		--change type
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_ADD_TYPE)
		e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetValue(TYPE_EFFECT)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e4)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_REMOVE_TYPE)
		e5:SetValue(TYPE_NORMAL)
		token:RegisterEffect(e5)
	end
	Duel.SpecialSummonComplete()
	g:KeepAlive()
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE+PHASE_END)
	e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetReset(RESET_PHASE+PHASE_END,2)
	e0:SetCountLimit(1)
	e0:SetLabel(fid,Duel.GetTurnCount())
	e0:SetLabelObject(g)
	e0:SetCondition(cm.descon)
	e0:SetOperation(cm.desop)
	Duel.RegisterEffect(e0,tp)
	local e6=Effect.CreateEffect(e:GetHandler())
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e6:SetTargetRange(1,0)
	e6:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e6,tp)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e7,tp)
end
function cm.desfilter(c,fid)
	return c:GetFlagEffectLabel(75000057)==fid
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local fid,turn=e:GetLabel()
	local g=e:GetLabelObject()
	if Duel.GetTurnCount()~=turn then
		if not g:IsExists(cm.desfilter,1,nil,fid) then
			g:DeleteGroup()
			e:Reset()
			return false
		else return true end
	end
	return false
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local fid,turn=e:GetLabel()
	local g=e:GetLabelObject()
	local tg=g:Filter(cm.desfilter,nil,fid)
	g:DeleteGroup()
	Duel.Destroy(tg,REASON_EFFECT)
end
function cm.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(1-tp)
end
function cm.damcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,nil)*100
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function cm.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=Duel.GetMatchingGroupCount(nil,tp,LOCATION_MZONE,0,nil)*100
	Duel.Damage(p,dam,REASON_EFFECT)
end
function cm.tgfilter(c)
	return ((c:IsSetCard(0xa751) and c:IsType(TYPE_MONSTER)) or c:IsCode(75000001))and c:IsAbleToGrave()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end