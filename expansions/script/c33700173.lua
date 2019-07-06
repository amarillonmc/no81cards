--动物朋友 九尾狐
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function c33700173.initial_effect(c)
	Senya.AddSummonSE(c,aux.Stringid(33700173,1))
	Senya.AddAttackSE(c,aux.Stringid(33700173,2))
	  --synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(nil))
	c:EnableReviveLimit() 
   --indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c33700173.con)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x442))
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33700173,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c33700173.tg)
	e3:SetOperation(c33700173.op)
	c:RegisterEffect(e3)
end
function c33700173.con(e)
	 local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),0,LOCATION_GRAVE,nil)
	return g:GetClassCount(Card.GetCode)<g:GetCount()
end
function c33700173.cgfilter(c)
	return c:IsSetCard(0x442) and c:IsFaceup()
end
function c33700173.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetMatchingGroupCount(c33700173.cgfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return ct>0 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
	Duel.Hint(HINT_SOUND,0,aux.Stringid(33700173,3))
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,ct,0,0)
end
function c33700173.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c33700173.cgfilter,tp,LOCATION_MZONE,0,nil)
	local cg=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if ct>0 and cg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=cg:Select(tp,1,ct,nil)
		local tg=Duel.SendtoGrave(sg,REASON_EFFECT)
		if tg>1 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SKIP_BP)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1,0)
			e1:SetReset(RESET_PHASE+PHASE_BATTLE+RESET_SELF_TURN)
			Duel.RegisterEffect(e1,tp)
		end
	end
end