--承天之魔导礼
local s,id=GetID()
local SET_MAGIDOREI=0xcd70
local CARD_BOOK_OF_MOON=14087893
local CARD_FORBIDDEN_CHALICE=25789292
local CARD_MST=5318639
local CARD_MAGIDOREI_GAOLIANG=21401210
local CARD_MAGIDOREI_XUANJIU=21401211
local CARD_MAGIDOREI_LUANDAO=21401212

function s.initial_effect(c)
	c:EnableReviveLimit()
	--「魔导礼」怪兽×2
	aux.AddFusionProcFunRep(c,s.ffilter,2,true)
	--①：特殊召唤的场合必定发动。对方场上的效果怪兽无效化
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.distg)
	e1:SetOperation(s.disop)
	c:RegisterEffect(e1)
	--②：破坏代替
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetTarget(s.reptg)
	e2:SetValue(s.repval)
	e2:SetOperation(s.repop)
	c:RegisterEffect(e2)
	--③-1：墓地的「月之书」当作「魔导礼 稿鞂」
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_CODE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	e3:SetTarget(s.booktg)
	e3:SetValue(CARD_MAGIDOREI_GAOLIANG)
	c:RegisterEffect(e3)
	--③-2：墓地的「禁忌的圣杯」当作「魔导礼 玄酒」
	local e4=e3:Clone()
	e4:SetTarget(s.chalicetg)
	e4:SetValue(CARD_MAGIDOREI_XUANJIU)
	c:RegisterEffect(e4)
	--③-3：墓地的「旋风」当作「魔导礼 鸾刀」
	local e5=e3:Clone()
	e5:SetTarget(s.msttg)
	e5:SetValue(CARD_MAGIDOREI_LUANDAO)
	c:RegisterEffect(e5)
end

function s.ffilter(c,fc,sumtype,tp)
	return c:IsFusionSetCard(SET_MAGIDOREI) and c:IsFusionType(TYPE_MONSTER)
end

function s.disfilter(c,e)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
		and c:IsCanBeDisabledByEffect(e) and not c:IsImmuneToEffect(e)
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(s.disfilter,tp,0,LOCATION_MZONE,nil,e)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,#g,0,0)
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.disfilter,tp,0,LOCATION_MZONE,nil,e)
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
	end
end

function s.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsSetCard(SET_MAGIDOREI)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end

function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return eg:IsExists(s.repfilter,1,nil,tp)
			and c:IsAbleToExtra()
			and not (c:IsLocation(LOCATION_GRAVE) and c:IsHasEffect(EFFECT_NECRO_VALLEY))
	end
	return Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,1))
end

function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_REPLACE)
end

function s.booktg(e,c)
	return c:IsOriginalCodeRule(CARD_BOOK_OF_MOON)
end

function s.chalicetg(e,c)
	return c:IsOriginalCodeRule(CARD_FORBIDDEN_CHALICE)
end

function s.msttg(e,c)
	return c:IsOriginalCodeRule(CARD_MST)
end
