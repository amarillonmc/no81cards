--吞噬神明的薪王
if not pcall(function() require("expansions/script/c10171001") end) then require("script/c10171001") end
local m,cm=rscf.DefineCard(10171011)
function cm.initial_effect(c)
	local e1=rsds.ExtraSummonFun(c,m+3)
	local e2=rsef.SV_CANNOT_BE_TARGET(c,"effect",aux.tgoval)
	local e3,e4=rsef.SV_INDESTRUCTABLE(c,"battle,effect")
	local e5=rsef.I(c,{m,0},1,"rm","tg",LOCATION_MZONE,nil,nil,rstg.target(cm.rmfilter,"rm",rsloc.mg,rsloc.mg),cm.rmop)
	--local e6=rsef.FC(c,EVENT_PHASE_START+PHASE_DRAW,nil,nil,"cd",LOCATION_MZONE,cm.copyop)
end
function cm.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove() and not c:IsSetCard(0xc335)
end
function cm.rmop(e,tp)
	local c=rscf.GetFaceUpSelf(e)
	local tc=rscf.GetTargetCard()
	if not tc then return end
	local atk,def=tc:GetAttack(),tc:GetDefense()
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
		local e1,e2=rscf.QuickBuff(c,"atk+",atk,"def+",def)
		local mt=getmetatable(tc)
		cm.reg =Card.RegisterEffect 
		Card.RegisterEffect = cm.reg2
		if mt.initial_effect then
			mt.initial_effect(c)
		end
		Card.RegisterEffect = cm.reg
		--Duel.MajesticCopy(c,tc)
		--c:RegisterFlagEffect(m,rsreset.est,0,1,tc:GetOriginalCodeRule())
	end
end 
function cm.reg2(c,e)
	if e:IsHasType(EFFECT_TYPE_QUICK_F) then
		e:SetType((e:GetType()-EFFECT_TYPE_QUICK_F)|EFFECT_TYPE_QUICK_O)
		local flag1,flag2=e:GetProperty()
		e:SetProperty(flag1|EFFECT_FLAG_DELAY,flag2)
	end
	if e:IsHasType(EFFECT_TYPE_TRIGGER_F) then
		e:SetType((e:GetType()-EFFECT_TYPE_TRIGGER_F)|EFFECT_TYPE_TRIGGER_O)
	end
	e:SetReset(rsreset.est)
	if not e:IsActivated() then e:Reset() 
	else
		cm.reg(c,e)
	end
end
function cm.copyop(e,tp)
	local c=e:GetHandler()
	local codelist={c:GetFlagEffectLabel(m)}
	for _,code in pairs(codelist) do
		local tc=Duel.GetFirstMatchingCard(Card.IsOriginalCodeRule,tp,0xff,0xff,nil,code) or Duel.CreateToken(tp,code)
		Duel.MajesticCopy(c,tc)
	end
end
