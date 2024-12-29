--影陀罗
local cm,m=GetID()
function cm.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(cm.spcon)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--unsynchroable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return #eg==1 and eg:GetFirst():IsLevelAbove(1) --:IsSummonPlayer(tp)
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if not c:IsPublic() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,6))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e:GetHandler():RegisterEffect(e1)
	else
		e:GetHandler():RegisterFlagEffect(11451544,RESET_EVENT+RESETS_STANDARD,0,1)
		local eset={e:GetHandler():IsHasEffect(EFFECT_PUBLIC)}
		if #eset>0 then
			for _,ae in pairs(eset) do
				if ae:IsHasType(EFFECT_TYPE_SINGLE) then
					ae:Reset()
				else
					local tg=ae:GetTarget() or aux.TRUE
					ae:SetTarget(function(e,c,...) return tg(e,c,...) and c:GetFlagEffect(11451544)==0 end)
				end
			end
		end
	end
end
function cm.thfilter(c)
	return c:IsCode(m) and c:IsAbleToHand()
end
function cm.tdfilter(c)
	return c:IsAbleToHand() or (c:IsLocation(LOCATION_MZONE) and c:IsCanTurnSet())
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=eg:GetFirst()
	if chk==0 then
		return c:IsCanBeSpecialSummoned(e,0,tp,false,false) or 1==1
	end
	local lab=c:GetFlagEffectLabel(m)
	if lab then
		e:SetLabel(1+math.abs(lab-Duel.GetCurrentChain()))
	else
		e:SetLabel(0)
	end
	c:ResetFlagEffect(m)
	local ct=math.min(Duel.GetCurrentChain(),6)
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,Duel.GetCurrentChain(),aux.Stringid(m,9+ct))
	if ec:IsLocation(LOCATION_MZONE) and ec:IsFaceup() then
		Duel.SetTargetCard(eg)
	end
	if e:GetLabel()==1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if e:GetLabel()==1 and c:IsRelateToEffect(e) then
		if tc and tc:IsLevelAbove(1) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LEVEL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			e1:SetValue(tc:GetLevel())
			e:GetHandler():RegisterEffect(e1,true)
		end
		Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	elseif e:GetLabel()>1 and c:IsRelateToEffect(e) then
		local ct=math.min(e:GetLabel()-1,3)
		c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,e:GetLabel()-1,aux.Stringid(m,6+ct))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_DELAY)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetCondition(cm.fcon)
		e1:SetOperation(cm.fop)
		e1:SetLabel(e:GetLabel()-1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		c:RegisterEffect(e1)
	end
end
function cm.fcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_HAND)
end
function cm.fop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Draw(tp,e:GetLabel(),REASON_EFFECT)
	e:Reset()
end