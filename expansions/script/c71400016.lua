--幻异梦境-空中庭园
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400016.initial_effect(c)
	--Activate
	--See AddYumeFieldGlobal
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400016,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1)
	e1:SetCondition(c71400016.con1)
	e1:SetTarget(c71400016.tg1)
	e1:SetOperation(c71400016.op1)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetDescription(aux.Stringid(71400016,1))
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(c71400016.con2)
	e2:SetTarget(c71400016.tg2)
	e2:SetOperation(c71400016.op2)
	c:RegisterEffect(e2)
	--self to deck & activate field
	yume.AddYumeFieldGlobal(c,71400016,1)
end
function c71400016.con1(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function c71400016.filter1(c)
	return c:IsSetCard(0x714) and c:IsSummonable(true,nil)
end
function c71400016.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400016.filter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c71400016.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c71400016.filter1,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SUMMON_COST)
		e1:SetOperation(c71400016.regop)
		e1:SetLabelObject(c)
		tc:RegisterEffect(e1)
	end
end
function c71400016.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lc=e:GetLabelObject()
	local e1=Effect.CreateEffect(lc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e1:SetDescription(aux.Stringid(71400016,2))
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetValue(aux.imval1)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(lc)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetLabelObject(tc)
	e2:SetCondition(c71400016.reccon)
	e2:SetOperation(c71400016.recop)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(lc)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROY)
	e3:SetLabelObject(e2)
	e3:SetOperation(c71400016.checkop)
	e3:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e3)
	e:Reset()
end
function c71400016.checkop(e,tp,eg,ep,ev,re,r,rp)
	local e2=e:GetLabelObject()
	e2:SetLabel(1)
end
function c71400016.reccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c71400016.recop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,e:GetLabelObject():GetBaseAttack(),REASON_EFFECT)
	e:Reset()
end
function c71400016.con2(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c71400016.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c71400016.op2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end