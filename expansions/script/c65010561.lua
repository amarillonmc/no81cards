--友希兰
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(65010561)
function cm.initial_effect(c)
	--local e1=rscf.SetSummonCondition(c,nil,rsval.spconbe)
	local e2=rsef.FTO(c,EVENT_SUMMON_SUCCESS,{m,0},{1,m},"sp,atk,def","de",LOCATION_HAND,cm.spcon,nil,rsop.target2(cm.fun,rscf.spfilter2(),"sp"),cm.spop)
	local e5=rsef.RegisterClone(c,e2,"code",EVENT_SPSUMMON_SUCCESS)
	local e3=rsef.SV_INDESTRUCTABLE(c,"battle")
	local e4=rsef.QO_NEGATE(c,"neg",nil,"des",LOCATION_MZONE,rscon.negcon(cm.filter))
end
function cm.spcon(e,tp,eg)
	local tc=eg:GetFirst()
	return #eg==1 and tc:GetSummonPlayer() ~= tp and tc:IsFaceup()
end
function cm.fun(g,e,tp,eg)
	Duel.SetTargetCard(eg)
	Duel.SetChainLimit(cm.limit(eg:GetFirst()))
end
function cm.limit(c)
	return  function (e,lp,tp)
				return e:GetHandler()~=c
			end
end
function cm.spop(e,tp,eg)
	local c=rscf.GetSelf(e)
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	if c and rssf.SpecialSummon(c)>0 and tc then
		local code=tc:GetOriginalCode()
		local ba=tc:GetBaseAttack()
		local bd=tc:GetBaseDefense()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		e2:SetLabelObject(e1)
		e2:SetCode(EFFECT_SET_BASE_ATTACK)
		e2:SetValue(ba)
		c:RegisterEffect(e2)
		local e3=rsef.RegisterClone(c,e2,"code",EFFECT_SET_BASE_DEFENSE,"value",bd)
		local cid=c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1)
	end
end
function cm.filter(e,tp,re,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttack(e:GetHandler():GetAttack())
end