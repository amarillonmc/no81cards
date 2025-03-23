local s, id = GetID()

function s.initial_effect(c)
	-- 效果①
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(2,id)
	e1:SetCost(s.excost1)
	e1:SetOperation(s.exop)
	c:RegisterEffect(e1)
	
	 --效果②
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(2,71000114)
	e2:SetTarget(c71000114.xtg)
	e2:SetOperation(c71000114.xop)
	c:RegisterEffect(e2)
	--get effect
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(s.xcon)
	e3:SetValue(s.xval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--local e5=e3:Clone()
	--e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	--c:RegisterEffect(e5)
	--local e6=e3:Clone()
	--e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	--c:RegisterEffect(e6)
end

--===== 效果①处理 =====--
function s.excost1_filter(c)
	return c:IsAbleToRemove() and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_EXTRA)) and c:IsSetCard(0xe73)
end

function s.excost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.excost1_filter,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,1,c)
			and c:IsAbleToRemove()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE) 
	local g=Duel.SelectMatchingCard(tp,s.excost1_filter,tp,LOCATION_HAND+LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,c)
	g:AddCard(c)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function s.filter(c)
	return c:IsSetCard(0xe73) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end

function s.exop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(71000114,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	Duel.RegisterEffect(e3,tp)
end
		
--===== 效果②处理 =====--
function c71000114.xf(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsCode(71000100) 
end
function c71000114.xtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c71000114.xf(chkc) and chkc:IsControler(tp) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(c71000114.xf,tp,LOCATION_MZONE,0,1,c) and c:IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c71000114.xf,tp,LOCATION_MZONE,0,1,1,c)
end
function c71000114.xop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) and c:IsCanOverlay() then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()>0 then Duel.Overlay(tc,mg,false) end
		Duel.Overlay(tc,Group.FromCards(c))
	end
end

--
function s.xcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSetCard(0xe73)
end
function s.xval(e,c)
	return e:GetHandler():GetOverlayCount()*300
end
