--化尘决
local s,id,o=GetID()
local CodeList=1202000	--引力术卡号
function s.initial_effect(c)
	aux.AddCodeList(c,CodeList)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(s.reccon)
	e2:SetOperation(s.recop)
	c:RegisterEffect(e2)
	--Pos Change
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SET_POSITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(s.target)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetValue(POS_FACEUP_DEFENSE)
	c:RegisterEffect(e3)	
	--本代码抄袭自「天命教士」（16104200）
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_RELEASE)
	e4:SetOperation(s.MonToPenOp2)
	c:RegisterEffect(e4)
	--inactivatable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_INACTIVATE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetValue(s.effectfilter)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_DISEFFECT)
	e6:SetRange(LOCATION_SZONE)
	e6:SetValue(s.effectfilter)
	c:RegisterEffect(e6)
end
function s.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function s.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	Duel.Recover(tp,300,REASON_EFFECT)
end
function s.target(e,c)
	return c:IsLevelAbove(5) and c:IsFaceup()
end
function s.MonToPenOp2(e,tp)
	local c=e:GetHandler()
	if not c:IsPreviousLocation(LOCATION_DECK) then return end
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsForbidden() and c:CheckUniqueOnField(tp) then
		if Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			local g=Group.FromCards(c)
			g=g:Select(tp,1,1,nil)
			Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
			if Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,false) then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetCode(EFFECT_CANNOT_ACTIVATE)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e1:SetTargetRange(1,0)
				e1:SetValue(s.actlimit)
				e1:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e1,tp)
			end
			c:SetStatus(STATUS_EFFECT_ENABLED,true)
			
		end
	end
end
function s.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function s.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return tc:IsCode(CodeList) or aux.IsCodeListed(tc,CodeList)
end