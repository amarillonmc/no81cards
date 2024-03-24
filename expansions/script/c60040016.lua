--和平维系者·马龙
local cm,m,o=GetID()
function cm.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--code
	aux.EnableChangeCode(c,60040001,LOCATION_MZONE+LOCATION_GRAVE)
	--mzone limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_MAX_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCondition(cm.con)
	e2:SetValue(cm.value)
	c:RegisterEffect(e2)
	--advance summon limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UNRELEASABLE_SUM)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCondition(cm.con)
	e3:SetValue(cm.sumlimit)
	c:RegisterEffect(e3)
	--kaiser colosseum
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_KAISER_COLOSSEUM)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCondition(cm.con)
	e4:SetTargetRange(0,1)
	c:RegisterEffect(e4)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_MZONE,0,3,nil)
end
function cm.value(e,fp,rp,r)
	if rp==e:GetHandlerPlayer() or r~=LOCATION_REASON_TOFIELD then return 7 end
	local limit=Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)
	return limit>0 and limit or 7
end
function cm.sumlimit(e,c)
	local tp=e:GetHandlerPlayer()
	if c:IsControler(1-tp) then
		local mint,maxt=c:GetTributeRequirement()
		local x=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
		local y=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		local ex=Duel.GetMatchingGroupCount(Card.IsHasEffect,tp,LOCATION_MZONE,0,nil,EFFECT_EXTRA_RELEASE)
		local exs=Duel.GetMatchingGroupCount(Card.IsHasEffect,tp,LOCATION_MZONE,0,nil,EFFECT_EXTRA_RELEASE_SUM)
		if ex==0 and exs>0 then ex=1 end
		return y-maxt+ex+1 > x-ex
	else
		return false
	end
end