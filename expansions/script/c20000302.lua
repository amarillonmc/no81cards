--应敌模组-突袭
local m=20000302
local cm=_G["c"..m]
if not pcall(function() require("expansions/script/c20000300") end) then require("script/c20000300") end
function cm.initial_effect(c)
	local e0=fu.copy(c,m)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return Duel.GetAttacker():IsControler(1-tp)
	end)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		local tc=Duel.GetAttacker()
		if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,tc,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local tc=Duel.GetAttacker()
		if tc:IsRelateToBattle() and tc:IsFaceup() and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT+REASON_TEMPORARY)~=0 then
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(tc)
			e1:SetCountLimit(1)
			e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetLabelObject():GetFlagEffect(m)~=0
			end)
			e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				Duel.ReturnToField(e:GetLabelObject())
			end)
			Duel.RegisterEffect(e1,tp)
			if e:GetHandler():IsRelateToEffect(e)and e:GetHandler():IsLocation(LOCATION_HAND)and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
				Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetTarget(function(e,c)
		return c:IsSetCard(0xfd3) and c:IsLocation(LOCATION_HAND) and c:IsType(TYPE_MONSTER)
	end)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end
