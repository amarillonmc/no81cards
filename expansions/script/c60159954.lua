--开门！查水表！
function c60159954.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_TOHAND)
	e1:SetCountLimit(1,60159954+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c60159954.e1tg)
	e1:SetOperation(c60159954.e1op)
	c:RegisterEffect(e1)
	
	--act in hand
	--local e2=Effect.CreateEffect(c)
	--e2:SetDescription(aux.Stringid(10045474,0))
	--e2:SetType(EFFECT_TYPE_SINGLE)
	--e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	--e2:SetCondition(c60159954.handcon)
	--c:RegisterEffect(e2)
end

function c60159954.e1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,0)
end
function c60159954.e1op(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,0,LOCATION_HAND,nil,ac)
	if g:GetCount()>0 then
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(60159954,0))
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60159954,0))
		--forbidden
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EFFECT_FORBIDDEN)
		e1:SetTargetRange(0,0xff)
		e1:SetTarget(c60159954.bantg)
		e1:SetLabel(ac)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
	else
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(60159954,1))
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60159954,1))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		e1:SetTargetRange(1,0)
		Duel.RegisterEffect(e1,tp)
	end
end
function c60159954.bantg(e,c)
	local fcode=e:GetLabel()
	return c:IsOriginalCodeRule(fcode)
end
function c60159954.splimit(e,c)
	return c:IsType(TYPE_MONSTER)
end

function c60159954.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end