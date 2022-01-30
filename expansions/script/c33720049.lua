--虚拟YouTuber的礼赞 绊爱 | VTuber Memoria - Kizuna Ai
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_CYBERSE),3,3)
	--special summon rule
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.hspcon)
	e0:SetTarget(s.hsptg)
	e0:SetOperation(s.hspop)
	c:RegisterEffect(e0)
	--material limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e1:SetValue(s.matlimit)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e3)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e4)
	--banish
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_REMOVE+CATEGORY_RECOVER)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(s.rmcon)
	e5:SetTarget(s.rmtg)
	e5:SetOperation(s.rmop)
	c:RegisterEffect(e5)
end
function s.rfilter(c,tp)
	return (c:IsControler(tp) or c:IsFaceup()) and c:IsSetCard(0x344c) and (c:IsType(TYPE_MONSTER) or c:IsLocation(LOCATION_MZONE))
end
function s.fselect(g,tp,c)
	return g:GetClassCount(Card.GetCode)==#g and Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and Duel.CheckReleaseGroupEx(tp,aux.IsInGroup,#g,nil,g)
end
function s.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetReleaseGroup(tp,true):Filter(s.rfilter,c,tp)
	return rg:CheckSubGroup(s.fselect,3,3,tp,c)
end
function s.hsptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local rg=Duel.GetReleaseGroup(tp,true):Filter(s.rfilter,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,s.fselect,true,3,3,tp,c)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end

function s.matlimit(e,c)
	if not c then return false end
	return c:IsLocation(LOCATION_EXTRA) and not c:IsSetCard(0x445)
end

function s.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function s.rmfilter(c)
	return c:IsSetCard(0x445,0x344c) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and (not c:IsLocation(LOCATION_MZONE) or c:IsFaceup())
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,nil)
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE+LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,ct,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.sumlimit)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(id,4))
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e3,tp)
	local e4=e1:Clone()
	e4:SetDescription(aux.Stringid(id,5))
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetValue(s.aclimit)
	Duel.RegisterEffect(e4,tp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.rmfilter),tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,nil)
	if #g>0 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
		local sg=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		Duel.Recover(tp,#sg*800,REASON_EFFECT)
	end
end
function s.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(id,33700346,33701323)
end
function s.aclimit(e,re,tp)
	return re:GetHandler():IsCode(id,33700346,33701323) and re:IsActiveType(TYPE_MONSTER)
end