--绛胧烈刃谱线投影
local m=11451718
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetTarget(cm.tktg)
	e2:SetOperation(cm.tkop)
	c:RegisterEffect(e2)
end
function cm.rmfilter(c)
	return c:IsSetCard(0x3977) and c:IsType(TYPE_MONSTER) and not cm[c:GetOriginalCode()]
end
function cm.rmfilter2(c)
	return c:IsSetCard(0x3977) and c:IsType(TYPE_MONSTER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.rmfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.rmfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	if not tc.mvcon or not tc.mvop then return end
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local sg=Duel.GetMatchingGroup(cm.rmfilter2,0,0xff,0xff,nil)
	for sc in aux.Next(sg) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_MOVE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_DELAY)
		e1:SetLabel(fid)
		e1:SetCondition(tc.mvcon)
		e1:SetOperation(function(...) if Duel.GetFlagEffect(0,0xffffff+m+fid)~=0 then return end tc.mvop(...) end)
		sc:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(0xff,0xff)
	e2:SetTarget(cm.eftg)
	e2:SetLabelObject(e1)
	--Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(tc:GetOriginalCode(),3))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e3:SetTargetRange(1,0)
	e3:SetCode(m)
	e3:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) if r==fid then Duel.RegisterFlagEffect(0,0xffffff+m+fid,RESET_PHASE+PHASE_END,0,1) end end)
	Duel.RegisterEffect(e3,tp)
	cm[tc:GetOriginalCode()]=true
end
function cm.eftg(e,c)
	return cm.rmfilter(c)
end
function cm.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,11451720,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_PSYCHO,ATTRIBUTE_DARK,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,tp,0)
end
function cm.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,11451720,0,TYPES_TOKEN_MONSTER,2000,2000,4,RACE_PSYCHO,ATTRIBUTE_DARK,POS_FACEUP,1-tp) then
		local token=Duel.CreateToken(tp,11451720)
		Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)
	end
end