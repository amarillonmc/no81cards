local s,id,o=GetID()
function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
	-- 添加全局效果监控额外卡组特殊召唤
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
	ge1:SetOperation(s.regop)
	Duel.RegisterEffect(ge1,0)
	--remove monster
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,id,EVENT_SPSUMMON_SUCCESS)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(custom_code)
	e2:SetCountLimit(1)
	e2:SetTarget(s.remtg1)
	e2:SetOperation(s.remop1)
	c:RegisterEffect(e2)
    	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(s.tdcon)
	e3:SetTarget(s.tdtg)
	e3:SetOperation(s.tdop)
	c:RegisterEffect(e3)
end

-- 记录任何玩家从额外卡组特殊召唤
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		local loc=tc:GetSummonLocation()
		if loc==LOCATION_EXTRA then
			local p=tc:GetSummonPlayer()
			Duel.RegisterFlagEffect(p,id,RESET_DISABLE,0,1)
		end
	end
end

-- 特殊召唤条件
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetFlagEffect(1-tp,id)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

function s.filter(c,e,tp)
	return c:IsSummonPlayer(1-tp) and c:IsLocation(LOCATION_MZONE) and c:IsAbleToRemove()
		and (not e or c:IsRelateToEffect(e))
end
function s.remtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(s.filter,1,nil,nil,tp) end
	local g=eg:Filter(s.filter,nil,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1200)
end
function s.remop1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(s.filter,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 and (tc:IsLocation(LOCATION_REMOVED) or tc:IsType(TYPE_TOKEN)) then
		Duel.Damage(1-tp,800,REASON_EFFECT)
	end
end

function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=e:GetHandler():GetPreviousLocation()
	return loc&(LOCATION_HAND|LOCATION_DECK)==0
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end