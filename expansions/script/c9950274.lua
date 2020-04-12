--fate·阿荣
function c9950274.initial_effect(c)
	   --link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xba5),2,99,c9950274.lcheck)
	c:EnableReviveLimit()
  --spsummon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	e3:SetTarget(c9950274.sumlimit)
	c:RegisterEffect(e3)
 --draw
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c9950274.condition)
	e3:SetTarget(c9950274.target)
	c:RegisterEffect(e3)
 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950274.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950274.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950274,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950274,3))
end
function c9950274.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x9ba7)
end
function c9950274.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA)
end
function c9950274.cfilter(c,tp)
	return c:IsSetCard(0xba5) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_RITUAL)
end
function c9950274.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9950274.cfilter,1,nil,tp)
end
function c9950274.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsPlayerCanDraw(tp,1)
	local g=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)
	local b2=g:GetCount()>0
	if chk==0 then return b1 or b2 end
	local sel=0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	if b1 and b2 then
		sel=Duel.SelectOption(tp,aux.Stringid(9950274,1),aux.Stringid(9950274,2))
	elseif b1 then
		sel=Duel.SelectOption(tp,aux.Stringid(9950274,1))
	else
		sel=Duel.SelectOption(tp,aux.Stringid(9950274,2))+1
	end
	if sel==0 then
		e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
		e:SetOperation(c9950274.drop)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		e:SetCategory(CATEGORY_DESTROY)
		e:SetOperation(c9950274.desop)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	end
end
function c9950274.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950274,0))
end
function c9950274.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950274,0))
end
