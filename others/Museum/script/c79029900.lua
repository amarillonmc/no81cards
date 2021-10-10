--个人行动-影霄·奔夜
function c79029900.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,79029900)
	e1:SetTarget(c79029900.sptg)
	e1:SetOperation(c79029900.spop)
	c:RegisterEffect(e1)	
	--link
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,09029900)
	e2:SetCost(c79029900.lkcost)
	e2:SetTarget(c79029900.lktg)
	e2:SetOperation(c79029900.lkop)
	c:RegisterEffect(e2)
	--cd
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e3:SetProperty(EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c79029900.cdtg)
	e3:SetTargetRange(LOCATION_MZONE,0)
	c:RegisterEffect(e3)
end
function c79029900.spfil(c,e,tp)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_LINK) and c:IsLinkBelow(3)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c79029900.ckfil(c)
	return c:IsSetCard(0xa900) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c79029900.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029900.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp) and eg:IsExists(c79029900.ckfil,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79029900.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c79029900.spfil,tp,LOCATION_EXTRA,0,nil,e,tp)
	if g:GetCount()<=0 then return end 
	Debug.Message("死亡应该铭刻在我们的记忆里，永不遗忘，无论这死亡是谁带来的，又是被带给了谁。我们的错误永远不会变成正确......那些疤痕应该要一直提醒我们，警告我们有多脆弱。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029900,0))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Select(tp,1,1,nil)
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79029900.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c79029900.splimit(e,c)
	return not c:IsSetCard(0xa900)
end
function c79029900.lkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c79029900.filter(c,mg)
	return c:IsLinkSummonable(nil) and c:IsSetCard(0xa900)
end
function c79029900.lmfil(c)
	return c:IsSetCard(0xa900) and c:IsCanBeLinkMaterial(nil)
end
function c79029900.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(c79029900.lmfil,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029900.filter,tp,LOCATION_EXTRA,0,1,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c79029900.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c79029900.lmfil,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c79029900.filter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
	local tc=g:GetFirst()
	if tc then
	if tc:IsCode(79029359) then 
	Debug.Message("好的，我知道了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029900,2))
	else
	Debug.Message("行动开始。我们走！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029900,1)) 
	end
		Duel.LinkSummon(tp,tc,mg)
	end
end
function c79029900.cdtg(e,c)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_LINK)
end
