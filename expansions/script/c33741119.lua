--Enter the Dragon!
function c33741119.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_HANDES_SELF+CATEGORY_DECKDES+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c33741119.condition)
	e1:SetTarget(c33741119.target)
	e1:SetOperation(c33741119.activate)
	c:RegisterEffect(e1)
end
function c33741119.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c33741119.hfilter(c,e,tp,atk)
	return c:IsAttackAbove(atk) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33741119.dfilter(c,e,tp,lv)
	local g=Duel.GetMatchingGroup(c33741119.disfilter,tp,LOCATION_HAND,0,nil)
	return c:IsLevelAbove(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g:CheckSubGroup(c33741119.gcheck,1,#g,c:GetLevel())
end
function c33741119.gcheck(g,lv)
	return g:GetSum(Card.GetLevel)==lv
end
function c33741119.disfilter(c)
	return c:IsDiscardable(REASON_EFFECT) and c:IsLevelAbove(1)
end
function c33741119.GetLevel(c)
	if c:IsType(TYPE_LINK) then return c:GetLink()
	elseif c:IsType(TYPE_XYZ) then return c:GetRank()
	else return c:GetLevel() end
end
function c33741119.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk,lv=eg:GetFirst():GetAttack(),c33741119.GetLevel(eg:GetFirst())
	local b1=Duel.IsExistingMatchingCard(c33741119.hfilter,tp,LOCATION_HAND,0,1,nil,e,tp,atk+1)
	local b2=Duel.IsExistingMatchingCard(c33741119.dfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv*2)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and (b1 or b2) end
end
function c33741119.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if not tc:IsRelateToBattle() or Duel.GetMZoneCount(tp)<=0 then return end
	local atk,lv=tc:GetAttack(),c33741119.GetLevel(tc)
	local b1=Duel.IsExistingMatchingCard(c33741119.hfilter,tp,LOCATION_HAND,0,1,nil,e,tp,atk+1)
	local b2=Duel.IsExistingMatchingCard(c33741119.dfilter,tp,LOCATION_DECK,0,1,nil,e,tp,lv*2)
	if not (b1 or b2) then return end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(33741119,0)},
		{b2,aux.Stringid(33741119,1)})
	local sc=nil
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sc=Duel.SelectMatchingCard(tp,c33741119.hfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp,atk+1):GetFirst()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		sc=Duel.SelectMatchingCard(tp,c33741119.dfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv*2):GetFirst()
		local g=Duel.GetMatchingGroup(c33741119.disfilter,tp,LOCATION_HAND,0,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		local sg=g:SelectSubGroup(tp,c33741119.gcheck,false,1,#g,sc:GetLevel())
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	end
	Duel.SpecialSummon(sc,0,tp,tp,true,false,POS_FACEUP)
	local fid=e:GetHandler():GetFieldID()
	sc:RegisterFlagEffect(33741119,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1,fid)
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e0:SetLabelObject(sc)
	e0:SetLabel(fid)
	e0:SetCountLimit(1)
	e0:SetCondition(c33741119.damcon)
	e0:SetOperation(c33741119.damop)
	e0:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e0,tp)
	--counter
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetLabelObject(e0)
	e1:SetCondition(c33741119.rscon)
	e1:SetOperation(c33741119.rsop)
	Duel.RegisterEffect(e1,tp)
end
function c33741119.damcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetFlagEffectLabel(33741119)==e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function c33741119.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,33741119)
	Duel.Damage(1-tp,e:GetLabelObject():GetAttack(),REASON_EFFECT)
end
function c33741119.rscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()==e:GetLabelObject():GetLabelObject()
end
function c33741119.rsop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():Reset()
	e:Reset()
end
