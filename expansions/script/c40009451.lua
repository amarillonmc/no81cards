--超古代龙 燃烧革律翁
if not pcall(function() require("expansions/script/c40008000") end) then require("script/c40008000") end
local m,cm = rscf.DefineCard(40009451)
if rsad then return end
rsad=cm 
function rsad.RitualFun(c)
	aux.AddCodeList(c,40009452)
	local e1=rscf.SetSummonCondition(c,false,aux.ritlimit)
	return e1
end
function rsad.ToHandFun(c,code)
	local e1=rsef.FTO(c,EVENT_TO_GRAVE,"th",{1,code},"th,atk,def","de,tg",LOCATION_MZONE,nil,nil,cm.thftg,cm.thfop)
	return e1
end
function cm.thftgc(c,e,tp)
	return c:IsRace(RACE_DINOSAUR) and c:IsControler(tp) and c:IsCanBeEffectTarget(e) and c:IsAbleToHand()
end
function cm.thftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tg=eg:Filter(cm.thftgc,nil,e,tp)
	if chkc then return tg:IsContains(chkc) end
	if chk==0 then return #tg>0 end
	if #tg==1 then
		Duel.SetTargetCard(tg)
	else
		rshint.Select(tp,"th")
		Duel.SetTargetCard(tg:Select(tp,1,1,nil))
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,1,0,0)
end
function cm.thfop(e,tp)
	local tc,c=rscf.GetTargetCard(),rscf.GetFaceUpSelf(e)
	if not tc or Duel.SendtoHand(tc,nil,REASON_EFFECT)<=0 or not tc:IsLocation(LOCATION_HAND) or not c then return end
	local e1,e2=rscf.QuickBuff(c,"atk+,def+",{tc:GetAttack(),tc:GetDefense()})
end
function rsad.TributeSFun(c,code,cate,flag,tg,op,isquick)
	local e1=rsef.QO(c,nil,{code,0},{1,code},cate,flag,LOCATION_HAND+LOCATION_MZONE,nil,rscost.reglabel(100),tg,op)
	if not isquick then 
		e1:SetType(EFFECT_TYPE_IGNITION)
	end
	return e1
end
function rsad.TributeSFun2(c,code,cate,flag,tg,op,isquick)
	local e1=rsef.QO(c,nil,{code,0},{1,code},cate,flag,LOCATION_HAND+LOCATION_MZONE,nil,rscost.cost(cm.tfcfilter,"res",LOCATION_HAND+LOCATION_MZONE),tg,op)
	if not isquick then 
		e1:SetType(EFFECT_TYPE_IGNITION)
	end
	return e1
end
function cm.tfcfilter(c,e,tp)
	local rc=e:GetHandler()
	return (c==rc and rc:IsLocation(LOCATION_HAND)) or (c:IsOnField() and rc:IsRace(RACE_DINOSAUR))
end
function rsad.TributeTFun(c,code,cate,flag,tg,op)
	local e1=rsef.STO(c,EVENT_RELEASE,{code,1},nil,cate,flag,cm.tstcon,nil,tg,op)
	return e1
end
function cm.tstcon(e)
	return e:GetHandler():IsReason(REASON_EFFECT+REASON_COST)
end
------------------
function cm.initial_effect(c)
	local e1=rsad.RitualFun(c)
	local e2=rsad.ToHandFun(c,m)
	local e3=rsef.QO(c,EVENT_CHAINING,"neg",nil,"neg,atk,def,res","dsp,dcal,tg",LOCATION_MZONE,cm.negcon,nil,cm.negtg,cm.negop)
end
function cm.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local rc,c=re:GetHandler(),e:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rc~=c and Duel.IsChainNegatable(ev) and c:IsAttackAbove(rc:GetAttack()) and c:IsDefenseAbove(rc:GetDefense()) and rc:IsLocation(rsloc.og+LOCATION_REMOVED) and rc:IsRelateToEffect(re)
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc:IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(rc)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,eg,1,0,0)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc,c=rscf.GetTargetCard(),rscf.GetFaceUpSelf(e)
	if not rc or not c then return end
	local atk,def = rc:GetAttack(),rc:GetDefense()
	if not c:IsAttackAbove(atk) or not c:IsDefenseAbove(def) then return end
	local e1,e2=rscf.QuickBuff(c,"atk+,def+",{-atk,-def})
	if Duel.NegateActivation(ev) then
		Duel.Release(eg,REASON_EFFECT)
	end




end