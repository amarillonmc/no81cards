--玻利瓦尔·近卫干员-羽毛笔
function c79029915.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_CYBERSE),2,99,c79029915.lcheck)
	c:EnableReviveLimit()
	--extra material
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetTargetRange(LOCATION_HAND,0)
	e0:SetValue(c79029915.matval)   
	c:RegisterEffect(e0)
	--ov 
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetTarget(c79029915.ovtg)
	e1:SetOperation(c79029915.ovop)
	c:RegisterEffect(e1)
	--atk up 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c79029915.apop)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(c79029915.aaval)
	c:RegisterEffect(e2)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c79029915.desreptg)
	e2:SetValue(c79029915.desrepval)
	e2:SetOperation(c79029915.desrepop)
	c:RegisterEffect(e2)
end
function c79029915.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xa900)
end
function c79029915.matval(e,lc,mg,c,tp)
	if e:GetHandler()~=lc then return false,nil end
	return true,c:IsSetCard(0xa900)
end
function c79029915.ovfil(c)
	return c:IsCanOverlay() and c:IsSetCard(0xa900) 
end
function c79029915.ovtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c79029915.ovfil,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetMaterialCount()>0 end 
end 
function c79029915.ovop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("接下来可不能走神了呢。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029915,0)) 
	local c=e:GetHandler()
	local x=e:GetHandler():GetMaterialCount()
	local g=Duel.GetMatchingGroup(c79029915.ovfil,tp,LOCATION_GRAVE+LOCATION_DECK,0,nil)  
	if g:GetCount()>0 then 
	local og=g:Select(tp,1,x,nil) 
	Duel.Overlay(c,og)
	end
end
function c79029915.aaval(e)
	return e:GetHandler():GetOverlayCount()
end
function c79029915.apop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,79029915)==0 then 
	Debug.Message("好哦。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029915,1)) 
	Duel.RegisterFlagEffect(tp,79029915,RESET_PHASE+PHASE_END,0,1)
	else
	end	
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(300)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	Duel.Recover(tp,300,REASON_EFFECT)
end
function c79029915.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function c79029915.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(c79029915.repfilter,1,nil,tp)
		and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function c79029915.desrepval(e,c)
	return c79029915.repfilter(c,e:GetHandlerPlayer())
end
function c79029915.desrepop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_EFFECT)
	Duel.Hint(HINT_CARD,0,79029915)
	Debug.Message("比想象的要费劲一点呢......")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029915,2)) 
end










