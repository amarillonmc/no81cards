mfszy=mfszy or {}

function mfszy.qqing(f,a,b,c)
	return  function(target)
				return f(target,a,b,c)
			end
end
function mfszy.qing(c,code1)
	if not c:IsStatus(STATUS_COPYING_EFFECT) and c.fit_monster==nil then
		local code=c:GetOriginalCode()
		local mt=_G["c" .. code]
		mt.fit_monster={code1}
	end
	mfszy.qingsp(c,mfszy.qqing(Card.IsCode,code1))
end
function mfszy.qingsp(c,filter)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1007001,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(mfszy.qingsptg(filter))
	e1:SetOperation(mfszy.qingspop(filter))
	c:RegisterEffect(e1)
end
function mfszy.qingfilter(c,e,tp,m)
	if not c:IsSetCard(0xc20f) or bit.band(c:GetType(),0x81)~=0x81
		or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) or c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local mg=m:Filter(Card.IsCanBeRitualMaterial,c,c)
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,nil)
	end
	return mg:CheckWithSumEqual(Card.GetRitualLevel,c:GetLevel(),1,99,c)
end
function mfszy.qingsptg(filter)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then
			local mg=Duel.GetRitualMaterial(tp)
			local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
			return ft>-1 and Duel.IsExistingMatchingCard(mfszy.qingfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,mg)
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
		end
end
function mfszy.qingspop(filter)
	return  function(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,mfszy.qingfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp,mg)
	local tc=tg:GetFirst()
		   if tc then
			  mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
			  if ft>0 then
			  if tc.mat_filter then
			  mg=mg:Filter(tc.mat_filter,nil)
			  end
			  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			  local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,99,tc)
			  tc:SetMaterial(mat)
			  Duel.ReleaseRitualMaterial(mat)
			  Duel.BreakEffect()
			  Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			  local e1=Effect.CreateEffect(c)
			  e1:SetDescription(aux.Stringid(1007001,2))
			  e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			  e1:SetType(EFFECT_TYPE_SINGLE)
			  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			  e1:SetRange(LOCATION_MZONE)
			  e1:SetCode(EFFECT_IMMUNE_EFFECT)
			  e1:SetValue(mfszy.mofaqing)
			  e1:SetTargetRange(0,1)
			  e1:SetReset(RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN)
			  tc:RegisterEffect(e1)
			  Duel.SpecialSummonComplete()
			  tc:CompleteProcedure()
			end
		end
	end
end
function mfszy.mofaqing(e,te)
	return te:IsActiveType(TYPE_MONSTER) and e:GetHandlerPlayer()~=te:GetHandlerPlayer()
end