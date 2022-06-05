--链环傀儡 光子
local m=40010182
local cm=_G["c"..m]
cm.named_with_linkjoker=1
function cm.linkjoker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_linkjoker
end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,cm.matfilter,1,1)	
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.regcon)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.rmcon)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
	--atk gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(cm.atkcon)
	e3:SetTarget(cm.atktg)
	e3:SetValue(900)
	c:RegisterEffect(e3)
	
end
function cm.matfilter(c)
	return cm.linkjoker(c)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(m) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function cm.rmcfilter(c)
	return not c:IsType(TYPE_LINK)
end
function cm.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and Duel.IsExistingMatchingCard(cm.rmcfilter,c:GetControler(),0,LOCATION_EXTRA,1,nil)
end
function cm.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_ATTACK) and not c:IsType(TYPE_LINK)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
	--Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(1-tp,cm.filter,1-tp,LOCATION_EXTRA,0,1,1,nil,e,1-tp)
		local tc=g:GetFirst()
		if tc and Duel.SpecialSummon(tc,0,1-tp,1-tp,false,false,POS_FACEDOWN_ATTACK)~=0 then
			tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
			local e6=Effect.CreateEffect(e:GetHandler())
			e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e6:SetCode(EVENT_PHASE+PHASE_END)
			e6:SetCountLimit(1)
			e6:SetReset(RESET_PHASE+RESETS_STANDARD-RESET_TURN_SET)
			e6:SetCondition(cm.flipcon)
			e6:SetOperation(cm.flipop)
			e6:SetLabelObject(tc)
			Duel.RegisterEffect(e6,tp)
			local e7=Effect.CreateEffect(e:GetHandler())
			e7:SetType(EFFECT_TYPE_SINGLE)
			e7:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
			--e7:SetCondition(cm.rcon)
			e7:SetReset(RESET_EVENT+RESETS_STANDARD)
			Duel.RegisterEffect(e7,tp)
			local e8=Effect.CreateEffect(e:GetHandler())
			e8:SetType(EFFECT_TYPE_SINGLE)
			e8:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e8:SetReset(RESET_EVENT+RESETS_STANDARD)
			Duel.RegisterEffect(e8,tp)
		end
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

function cm.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:IsFacedown() and Duel.GetTurnPlayer()==tc:GetControler() and tc:GetFlagEffect(m)~=0 and Duel.GetFlagEffect(tp,40010160)==0
end
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
end
function cm.lkfilter(c)
	return c:IsFaceup() and (c:IsCode(40010184) or c:IsCode(40010186))
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetMutualLinkedGroup()
	return g:IsExists(cm.lkfilter,1,nil)
end
function cm.atktg(e,c)
	return e:GetHandler():GetMutualLinkedGroup():IsContains(c)
end

